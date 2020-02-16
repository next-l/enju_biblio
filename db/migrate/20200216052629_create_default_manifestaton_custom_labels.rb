class CreateDefaultManifestatonCustomLabels < ActiveRecord::Migration[5.2]
  def change
    create_table :default_manifestaton_custom_labels do |t|
      t.references :library_group, foreign_key: true, null: false
      t.string :label, null: false

      t.timestamps
    end
    add_index :default_manifestaton_custom_labels, :label, unique: true
  end
end
