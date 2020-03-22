class CreateCustomManifestationLabels < ActiveRecord::Migration[5.2]
  def change
    create_table :custom_manifestation_labels do |t|
      t.references :library_group, foreign_key: true, null: false
      t.string :label, null: false

      t.timestamps
    end
  end
end
