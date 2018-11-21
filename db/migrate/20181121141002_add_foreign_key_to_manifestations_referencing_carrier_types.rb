class AddForeignKeyToManifestationsReferencingCarrierTypes < ActiveRecord::Migration[5.1]
  def change
    add_foreign_key :manifestations, :carrier_types
    add_foreign_key :manifestations, :content_types
    add_foreign_key :manifestations, :frequencies
  end
end
