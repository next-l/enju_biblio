class CreateCustomManifestationProperties < ActiveRecord::Migration[5.2]
  def change
    create_table :custom_manifestation_properties do |t|
      t.string :name, null: false
      t.text :value
      t.references :manifestation, foreign_key: true, null: false

      t.timestamps
    end
  end
end
