class ResourceExportFileQueue
  @queue = :resource_export_file

  def self.perform(resource_export_id)
    ResourceExportFile.find(resource_export_id).transition_to!(:started)
  end
end
