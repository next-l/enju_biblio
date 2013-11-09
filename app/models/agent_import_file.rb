class AgentImportFile < ActiveRecord::Base
  attr_accessible :agent_import, :edit_mode
  include ImportFile
  default_scope {order('agent_import_files.id DESC')}
  scope :not_imported, -> {where(:state => 'pending')}
  scope :stucked, -> {where('created_at < ? AND state = ?', 1.hour.ago, 'pending')}

  if Setting.uploaded_file.storage == :s3
    has_attached_file :agent_import, :storage => :s3, :s3_credentials => "#{Rails.root.to_s}/config/s3.yml",
      :s3_permissions => :private
  else
    has_attached_file :agent_import,
      :path => ":rails_root/private/system/:class/:attachment/:id_partition/:style/:filename"
  end
  validates_attachment_content_type :agent_import, :content_type => [
    'text/csv',
    'text/plain',
    'text/tab-separated-values',
    'application/octet-stream',
    'application/vnd.ms-excel'
  ]
  validates_attachment_presence :agent_import
  belongs_to :user, :validate => true
  has_many :agent_import_results

  state_machine :initial => :pending do
    event :sm_start do
      transition [:pending, :started] => :started
    end

    event :sm_complete do
      transition :started => :completed
    end

    event :sm_fail do
      transition :started => :failed
    end

    before_transition any => :started do |agent_import_file|
      agent_import_file.executed_at = Time.zone.now
    end

    before_transition any => :completed do |agent_import_file|
      agent_import_file.error_message = nil
    end
  end

  def import_start
    sm_start!
    case edit_mode
    when 'create'
      import
    when 'update'
      modify
    when 'destroy'
      remove
    else
      import
    end
  end

  def import
    reload
    num = {:agent_imported => 0, :user_imported => 0, :failed => 0}
    row_num = 2
    rows = open_import_file
    field = rows.first
    if [field['first_name'], field['last_name'], field['full_name']].reject{|field| field.to_s.strip == ""}.empty?
      raise "You should specify first_name, last_name or full_name in the first line"
    end
    #rows.shift

    rows.each do |row|
      next if row['dummy'].to_s.strip.present?
      import_result = AgentImportResult.create!(:agent_import_file_id => self.id, :body => row.fields.join("\t"))

      agent = Agent.new
      agent = set_agent_value(agent, row)

      if agent.save!
        import_result.agent = agent
        num[:agent_imported] += 1
        if row_num % 50 == 0
          Sunspot.commit
          GC.start
        end
      end

      #unless row['username'].to_s.strip.blank?
      #  user = User.new
      #  user.agent = agent
      #  set_user_value(user, row)
      #  if user.password.blank?
      #    user.set_auto_generated_password
      #  end
      #  if user.save!
      #    import_result.user = user
      #  end
      #  num[:user_imported] += 1
      #end

      import_result.save!
      row_num += 1
    end
    Sunspot.commit
    rows.close
    sm_complete!
    return num
  rescue => e
    self.error_message = "line #{row_num}: #{e.message}"
    sm_fail!
    raise e
  end

  def self.import
    AgentImportFile.not_imported.each do |file|
      file.import_start
    end
  rescue
    Rails.logger.info "#{Time.zone.now} importing agents failed!"
  end

  def modify
    sm_start!
    rows = open_import_file
    row_num = 2

    rows.each do |row|
      next if row['dummy'].to_s.strip.present?
      #user = User.where(:user_number => row['user_number'].to_s.strip).first
      #if user.try(:agent)
      #  set_agent_value(user.agent, row)
      #  user.agent.save!
      #  set_user_value(user, row)
      #  user.save!
      #end
      agent = Agent.where(:id => row['id']).first
      if agent
        agent.full_name = row['full_name'] if row['full_name'].to_s.strip.present?
        agent.full_name_transcription = row['full_name_transcription'] if row['full_name_transcription'].to_s.strip.present?
        agent.first_name = row['first_name'] if row['first_name'].to_s.strip.present?
        agent.first_name_transcription = row['first_name_transcription'] if row['first_name_transcription'].to_s.strip.present?
        agent.middle_name = row['middle_name'] if row['middle_name'].to_s.strip.present?
        agent.middle_name_transcription = row['middle_name_transcription'] if row['middle_name_transcription'].to_s.strip.present?
        agent.last_name = row['last_name'] if row['last_name'].to_s.strip.present?
        agent.last_name_transcription = row['last_name_transcription'] if row['last_name_transcription'].to_s.strip.present?
        agent.address_1 = row['address_1'] if row['address_1'].to_s.strip.present?
        agent.address_2 = row['address_2'] if row['address_2'].to_s.strip.present?
        agent.save!
      end
      row_num += 1
    end
    sm_complete!
  rescue => e
    self.error_message = "line #{row_num}: #{e.message}"
    sm_fail!
    raise e
  end

  def remove
    sm_start!
    rows = open_import_file
    row_num = 2

    rows.each do |row|
      next if row['dummy'].to_s.strip.present?
      agent = Agent.where(:id => row['id'].to_s.strip).first
      if agent
        agent.picture_files.destroy_all
        agent.reload
        agent.destroy
      end
      row_num += 1
    end
    sm_complete!
  rescue => e
    self.error_message = "line #{row_num}: #{e.message}"
    sm_fail!
    raise e
  end

  private
  def open_import_file
    tempfile = Tempfile.new('agent_import_file')
    if Setting.uploaded_file.storage == :s3
      uploaded_file_path = agent_import.expiring_url(10)
    else
      uploaded_file_path = agent_import.path
    end
    open(uploaded_file_path){|f|
      f.each{|line|
        if defined?(CharlockHolmes::EncodingDetector)
          begin
            string = line.encode('UTF-8', CharlockHolmes::EncodingDetector.detect(line)[:encoding])
          rescue StandardError
            string = NKF.nkf('-w -Lu', line)
          end
        else
          string = NKF.nkf('-w -Lu', line)
        end
        tempfile.puts(string)
      }
    }
    tempfile.close

    file = CSV.open(tempfile, :col_sep => "\t")
    header = file.first
    rows = CSV.open(tempfile, :headers => header, :col_sep => "\t")
    AgentImportResult.create!(:agent_import_file_id => self.id, :body => header.join("\t"))
    tempfile.close(true)
    file.close
    rows
  end

  def set_agent_value(agent, row)
    agent.first_name = row['first_name'] if row['first_name']
    agent.middle_name = row['middle_name'] if row['middle_name']
    agent.last_name = row['last_name'] if row['last_name']
    agent.first_name_transcription = row['first_name_transcription'] if row['first_name_transcription']
    agent.middle_name_transcription = row['middle_name_transcription'] if row['middle_name_transcription']
    agent.last_name_transcription = row['last_name_transcription'] if row['last_name_transcription']

    agent.full_name = row['full_name'] if row['full_name']
    agent.full_name_transcription = row['full_name_transcription'] if row['full_name_transcription']

    agent.address_1 = row['address_1'] if row['address_1']
    agent.address_2 = row['address_2'] if row['address_2']
    agent.zip_code_1 = row['zip_code_1'] if row['zip_code_1']
    agent.zip_code_2 = row['zip_code_2'] if row['zip_code_2']
    agent.telephone_number_1 = row['telephone_number_1'] if row['telephone_number_1']
    agent.telephone_number_2 = row['telephone_number_2'] if row['telephone_number_2']
    agent.fax_number_1 = row['fax_number_1'] if row['fax_number_1']
    agent.fax_number_2 = row['fax_number_2'] if row['fax_number_2']
    agent.note = row['note'] if row['note']
    agent.birth_date = row['birth_date'] if row['birth_date']
    agent.death_date = row['death_date'] if row['death_date']

    #if row['username'].to_s.strip.blank?
      agent.email = row['email'].to_s.strip
      agent.required_role = Role.where(:name => row['required_role_name'].to_s.strip.camelize).first || Role.friendly.find('Guest')
    #else
    #  agent.required_role = Role.where(:name => row['required_role_name'].to_s.strip.camelize).first || Role.friendly.find('Librarian')
    #end
    language = Language.where(:name => row['language'].to_s.strip.camelize).first
    language = Language.where(:iso_639_2 => row['language'].to_s.strip.downcase).first unless language
    language = Language.where(:iso_639_1 => row['language'].to_s.strip.downcase).first unless language
    agent.language = language if language
    country = Country.where(:name => row['country'].to_s.strip).first
    agent.country = country if country
    agent
  end

  #def set_user_value(user, row)
  #  user.operator = User.find(1)
  #  email = row['email'].to_s.strip
  #  if email.present?
  #    user.email = email
  #    user.email_confirmation = email
  #  end
  #  password = row['password'].to_s.strip
  #  if password.present?
  #    user.password = password
  #    user.password_confirmation = password
  #  end
  #  user.username = row['username'] if row['username']
  #  user.user_number = row['user_number'] if row['user_number']
  #  library = Library.where(:name => row['library_short_name'].to_s.strip).first || Library.web
  #  user_group = UserGroup.where(:name => row['user_group_name']).first || UserGroup.first
  #  user.library = library
  #  role = Role.where(:name => row['role_name'].to_s.strip.camelize).first || Role.friendly.find('User')
  #  user.role = role
  #  required_role = Role.where(:name => row['required_role_name'].to_s.strip.camelize).first || Role.friendly.find('Librarian')
  #  user.required_role = required_role
  #  locale = Language.where(:iso_639_1 => row['locale'].to_s.strip).first
  #  user.locale = locale || I18n.default_locale.to_s
  #  user
  #end
end

# == Schema Information
#
# Table name: agent_import_files
#
#  id                        :integer          not null, primary key
#  parent_id                 :integer
#  content_type              :string(255)
#  size                      :integer
#  user_id                   :integer
#  note                      :text
#  executed_at               :datetime
#  state                     :string(255)
#  agent_import_file_name    :string(255)
#  agent_import_content_type :string(255)
#  agent_import_file_size    :integer
#  agent_import_updated_at   :datetime
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  agent_import_fingerprint  :string(255)
#  error_message             :text
#  edit_mode                 :string(255)
#

