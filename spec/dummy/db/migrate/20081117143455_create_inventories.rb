class CreateInventories < ActiveRecord::Migration[5.0]
  def self.up
    create_table :inventories do |t|
      t.integer :item_id
      t.integer :inventory_file_id
      t.text :note

      t.timestamps
    end
    add_index :inventories, :item_id
    add_index :inventories, :inventory_file_id
  end

  def self.down
    drop_table :inventories
  end
end
