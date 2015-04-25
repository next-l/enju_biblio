class AddResourceExportIdToResourceExportFile < ActiveRecord::Migration
  def change
    add_column :resource_export_files, :resource_export_id, :string
    add_column :resource_export_files, :resource_export_size, :integer
    rename_column :resource_export_files, :resource_export_file_name, :resource_export_filename
    add_index :resource_export_files, :resource_export_id
  end
end
