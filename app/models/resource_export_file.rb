class ResourceExportFile < ActiveRecord::Base
  belongs_to :user
  has_attached_file :resource_export
  validates_attachment_content_type :resource_export, :content_type => /\Atext\/plain\Z/
  validates :user, presence: true
  attr_accessor :mode

  def export
    sleep 10
    tempfile = Tempfile.new(['resource_export_file', '.txt'])
    file = Manifestation.export(format: :tsv)
    tempfile.puts(file)
    tempfile.close
    self.resource_export = File.new(tempfile.path, "r")
    if save
      message = Message.create(
        sender: User.find(1),
        recipient: user.username,
        subject: 'export completed',
        body: I18n.t('export.export_completed')
      )
    end
  end
end

# == Schema Information
#
# Table name: resource_export_files
#
#  id                           :integer          not null, primary key
#  user_id                      :integer
#  resource_export_file_name    :string(255)
#  resource_export_content_type :string(255)
#  resource_export_file_size    :integer
#  resource_export_updated_at   :datetime
#  executed_at                  :datetime
#  created_at                   :datetime
#  updated_at                   :datetime
#
