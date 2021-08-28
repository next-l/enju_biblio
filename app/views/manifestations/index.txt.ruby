(Manifestation.csv_header(role: current_user_role_name) + Item.csv_header(role: current_user_role_name)).to_csv(col_sep: "\t") + @manifestations.map{|manifestation|
  if manifestation.items.empty?
    manifestation.to_hash(role: current_user_role_name).values.to_csv(col_sep: "\t")
  else
    manifestation.items.each do |item|
      (manifestation.to_hash(role: current_user_role_name).values + item.to_hash(role: current_user_role_name).values).to_csv(col_sep: "\t")
    end
  end
}.join
