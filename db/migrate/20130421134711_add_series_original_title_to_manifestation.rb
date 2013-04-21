class AddSeriesOriginalTitleToManifestation < ActiveRecord::Migration
  def change
    add_column :manifestations, :series_original_title, :text
    add_column :manifestations, :series_title_transcription, :text
    add_column :manifestations, :series_title_creator_string, :text
    add_column :manifestations, :series_title_volume_number_string, :text
  end
end
