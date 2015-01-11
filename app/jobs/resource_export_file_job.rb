class ResourceExportFileJob < ActiveJob::Base
  queue_as :default

  def perform(resource_export_file)
    resource_export_file.export!
  end
end
