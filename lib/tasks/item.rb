def update_item
  Exemplify.find_each do |exemplify|
    if exemplify.item
      exemplify.item.update_column(:manifestation_id, exemplify.manifestation_id) unless exemplify.item.manifestation_id
    end
  end
end
