class AddNumberOfPageStringToManifestation < ActiveRecord::Migration
  def change
    add_column :manifestations, :number_of_page_string, :string
  end
end
