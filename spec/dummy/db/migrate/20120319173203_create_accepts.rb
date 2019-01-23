class CreateAccepts < ActiveRecord::Migration[5.2]
  def change
    create_table :accepts do |t|
      t.references :basket, foreign_key: true
      t.references :item, foreign_key: true, type: :uuid
      t.references :librarian, foreign_key: true

      t.timestamps
    end
  end
end
