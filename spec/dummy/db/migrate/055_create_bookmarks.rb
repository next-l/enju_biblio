class CreateBookmarks < ActiveRecord::Migration[5.2]
  def change
    create_table :bookmarks do |t|
      t.references :user, foreign_key: true, null: false
      t.references :manifestation, foreign_key: true, null: false
      t.text :title
      t.string :url, index: true
      t.text :note
      t.boolean :shared, default: false, null: false

      t.timestamps
    end
  end
end
