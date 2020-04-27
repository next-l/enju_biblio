class AddUrlToLicense < ActiveRecord::Migration[5.2]
  def change
    add_column :licenses, :url, :string, index: {unique: true}
  end
end
