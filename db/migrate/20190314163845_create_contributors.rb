class CreateContributors < ActiveRecord::Migration[5.2]
  def change
    create_table :contributors do |t|
      t.references :realize, foreign_key: true, null: false
      t.references :agent, foreign_key: true, type: :uuid, null: false

      t.timestamps
    end
  end
end
