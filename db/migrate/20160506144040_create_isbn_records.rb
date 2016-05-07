class CreateIsbnRecords < ActiveRecord::Migration
  def change
    create_table :isbn_records do |t|
      t.string :body, index: true
      t.string :isbn_type
      t.string :source
      t.references :manifestation, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
