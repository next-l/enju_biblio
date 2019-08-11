class CreateCustomItemProperties < ActiveRecord::Migration[5.2]
  def change
    create_table :custom_item_properties do |t|
      t.references :item, foreign_key: true, null: false
      t.string :name, null: false
      t.text :value

      t.timestamps
    end
    add_index :custom_item_properties, :name
  end
end
