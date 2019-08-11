class CreateCustomManifestationProperties < ActiveRecord::Migration[5.2]
  def change
    create_table :custom_manifestation_properties do |t|
      t.references :manifestation, foreign_key: true, null: false
      t.string :name, null: false
      t.text :value

      t.timestamps
    end
    add_index :custom_manifestation_properties, :name
  end
end
