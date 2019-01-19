class CreateBookmarkStatHasManifestations < ActiveRecord::Migration[5.2]
  def change
    create_table :bookmark_stat_has_manifestations do |t|
      t.references :bookmark_stat, foreign_key: true, null: false
      t.references :manifestation
      t.integer :bookmarks_count

      t.timestamps
    end
  end
end
