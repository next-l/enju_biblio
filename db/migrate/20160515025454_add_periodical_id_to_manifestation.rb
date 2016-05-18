class AddPeriodicalIdToManifestation < ActiveRecord::Migration
  def change
    add_column :manifestations, :periodical_id, :integer
    add_index :manifestations, :periodical_id
  end
end
