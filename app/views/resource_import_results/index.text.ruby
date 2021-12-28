CSV.generate(col_sep: "\t", row_sep: "\r\n") do |csv|
  csv << %w(row_num manifestation item error_message)
  @resource_import_results.each_with_index do |result, i|
    csv << [i + 1, (manifestation_url(result.manifestation) if result.manifestation), (item_url(result.item) if result.item), result.error_message]
  end
end
