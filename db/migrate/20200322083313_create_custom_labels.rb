class CreateCustomLabels < ActiveRecord::Migration[5.2]
  def change
    create_table :custom_labels do |t|
      t.references :library_group, foreign_key: true, null: false
      t.string :label

      t.timestamps
    end
  end
end
