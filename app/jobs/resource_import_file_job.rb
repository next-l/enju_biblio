class ResourceImportFileJob < ActiveJob::Base
  queue_as :default

  def perform(resource_import_file)
    resource_import_file.import_start
  end
end
