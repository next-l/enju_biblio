class CreateManifestationRelationships < ActiveRecord::Migration[5.2]
  def change
    create_table :manifestation_relationships do |t|
      t.references :parent, foreign_key: {to_table: :agents}, null: false
      t.references :child, foreign_key: {to_table: :agents}, null: false
      t.references :manifestation_relationship_type, index: false

      t.timestamps
    end
  end
end
