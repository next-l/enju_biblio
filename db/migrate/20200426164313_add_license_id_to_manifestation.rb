class AddLicenseIdToManifestation < ActiveRecord::Migration[5.2]
  def change
    add_reference :manifestations, :license, foreign_key: true
  end
end
