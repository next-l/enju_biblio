class ResourceExportFile < ActiveRecord::Base
  belongs_to :user
  has_attached_file :resource_export
  validates_attachment_content_type :resource_export, :content_type => /\Atext\/plain\Z/

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
        body: t('export.export_completed')
      )
    end
  end
end
