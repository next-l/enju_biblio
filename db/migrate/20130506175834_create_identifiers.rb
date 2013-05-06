class CreateIdentifiers < ActiveRecord::Migration
  def change
    create_table :identifiers do |t|
      t.string :body
      t.integer :identifier_type_id
      t.integer :manifestation_id
      t.boolean :primary

      t.timestamps
    end
    add_index :identifiers, [:body, :identifier_type_id]
  end
end
