class CreateNdlaRecords < ActiveRecord::Migration[5.1]
  def change
    create_table :ndla_records do |t|
      t.references :agent, foreign_key: true, null: false
      t.string :body, null: false, index: {unique: true}

      t.timestamps
    end
  end
end
