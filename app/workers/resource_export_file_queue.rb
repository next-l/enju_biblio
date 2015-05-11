class ResourceExportFileQueue
  @queue = :enju_leaf

  def self.perform(resource_export_id)
    ResourceExportFile.find(resource_export_id).export!
  end
end
