class CreateCustomProperties < ActiveRecord::Migration[5.2]
  def change
    create_table :custom_properties do |t|
      t.string :name, null: false
      t.text :value
      t.integer :property_attachable_id, null: false
      t.string :property_attachable_type, null: false

      t.timestamps
    end
    add_index :custom_properties, [:name, :property_attachable_id, :property_attachable_type], unique: true, name: 'index_custom_properties_on_name_and_attachable_id_and_type'
  end
end
