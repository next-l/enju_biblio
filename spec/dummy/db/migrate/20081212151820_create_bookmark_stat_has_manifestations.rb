class CreateBookmarkStatHasManifestations < ActiveRecord::Migration[5.2]
  def change
    create_table :bookmark_stat_has_manifestations do |t|
      t.references :bookmark_stat, foreign_key: true, null: false, type: :uuid
      t.references :manifestation, type: :uuid
      t.integer :bookmarks_count

      t.timestamps
    end
  end
end
