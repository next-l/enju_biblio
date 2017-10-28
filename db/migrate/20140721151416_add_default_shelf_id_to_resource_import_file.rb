class AddDefaultShelfIdToResourceImportFile < ActiveRecord::Migration[5.0]
  def change
    add_column :resource_import_files, :default_shelf_id, :uuid
  end
end
