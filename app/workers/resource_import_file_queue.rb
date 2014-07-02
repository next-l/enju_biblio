class ResourceImportFileQueue
  @queue = :resource_import_file

  def self.perform(resource_import_file_id)
    ResourceImportFile.find(resource_import_file_id).import_start
  end
end
