class AddMetadataToManifestation < ActiveRecord::Migration[5.0]
  def change
    add_column :manifestations, :metadata, :jsonb, default: "{}"
  end
end
