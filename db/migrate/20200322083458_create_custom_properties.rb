class CreateCustomProperties < ActiveRecord::Migration[5.2]
  def change
    create_table :custom_properties do |t|
      t.integer :resource_id, null: false
      t.string :resource_type, null: false
      t.references :custom_label, foreign_key: true, null: false
      t.text :value

      t.timestamps
    end
  end
end
