class CreateCustomItemProperties < ActiveRecord::Migration[5.2]
  def change
    create_table :custom_item_properties do |t|
      t.string :name, null: false
      t.text :value
      t.references :item, foreign_key: true, null: false

      t.timestamps
    end
  end
end
