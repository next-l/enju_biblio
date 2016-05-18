class CreatePeriodicals < ActiveRecord::Migration
  def change
    create_table :periodicals do |t|
      t.text :original_title
      t.references :manifestation, index: true, foreign_key: true
      t.references :frequency, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
