class ResourceExportFile < ApplicationRecord
  include Statesman::Adapters::ActiveRecordQueries
  include ExportFile

  if ENV['ENJU_STORAGE'] == 's3'
    has_attached_file :resource_export, storage: :s3,
      s3_credentials: {
        access_key: ENV['AWS_ACCESS_KEY_ID'],
        secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
        bucket: ENV['S3_BUCKET_NAME'],
        s3_host_name: ENV['S3_HOST_NAME'],
        s3_region: ENV['S3_REGION']
      },
      s3_permissions: :private
  else
    has_attached_file :resource_export,
      path: ":rails_root/private/system/:class/:attachment/:id_partition/:style/:filename"
  end
  validates_attachment_content_type :resource_export, content_type: /\Atext\/plain\Z/

  has_many :resource_export_file_transitions, autosave: false, dependent: :destroy

  def state_machine
    ResourceExportFileStateMachine.new(self, transition_class: ResourceExportFileTransition)
  end

  delegate :can_transition_to?, :transition_to!, :transition_to, :current_state,
    to: :state_machine

  def export!
    transition_to!(:started)
    role_name = user.try(:role).try(:name)
    tempfile = Tempfile.new(['resource_export_file_', '.txt'])
    tempfile.puts(Manifestation.csv_header(role_name, col_sep: "\t"))
    Manifestation.find_each do |manifestation|
      tempfile.puts(manifestation.to_csv(format: :txt, role: role_name))
    end
    tempfile.close
    self.resource_export = File.new(tempfile.path, "r")
    save!
    transition_to!(:completed)
    mailer = ResourceExportMailer.completed(self)
    send_message(mailer)
  rescue => e
    transition_to!(:failed)
    mailer = ResourceExportMailer.failed(self)
    send_message(mailer)
    raise e
  end

  private
  def self.transition_class
    ResourceExportFileTransition
  end

  def self.initial_state
    :pending
  end
end

# == Schema Information
#
# Table name: resource_export_files
#
#  id                           :integer          not null, primary key
#  user_id                      :integer
#  resource_export_file_name    :string
#  resource_export_content_type :string
#  resource_export_file_size    :bigint
#  resource_export_updated_at   :datetime
#  executed_at                  :datetime
#  created_at                   :datetime
#  updated_at                   :datetime
#
