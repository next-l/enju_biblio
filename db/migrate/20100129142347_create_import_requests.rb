class CreateImportRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :import_requests do |t|
      t.string :isbn
      t.integer :manifestation_id
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :import_requests, :isbn
    add_index :import_requests, :manifestation_id
  end
end
