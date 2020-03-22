class CreateCustomProperties < ActiveRecord::Migration[5.2]
  def change
    create_table :custom_properties do |t|
      t.references :custom_label, polymorphic: true, null: false, index: {name: 'index_custom_properties_on_custom_label_type_and_id'}
      t.references :resource, polymorphic: true, null: false
      t.text :value, null: false

      t.timestamps
    end
  end
end
