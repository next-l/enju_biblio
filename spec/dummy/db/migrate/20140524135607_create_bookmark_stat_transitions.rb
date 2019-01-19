class CreateBookmarkStatTransitions < ActiveRecord::Migration[5.2]
  def change
    create_table :bookmark_stat_transitions do |t|
      t.string :to_state
      t.jsonb :metadata, default: {}
      t.integer :sort_key
      t.references :bookmark_stat
      t.timestamps
    end

    add_index :bookmark_stat_transitions, [:sort_key, :bookmark_stat_id], unique: true, name: "index_bookmark_stat_transitions_on_sort_key_and_stat_id"
  end
end
