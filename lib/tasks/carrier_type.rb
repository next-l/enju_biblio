def update_carrier_type
  cd = CarrierType.where(name: 'CD').first
  cd.update_column(:name, 'cd') if cd
  dvd = CarrierType.where(name: 'DVD').first
  dvd.update_column(:name, 'dvd') if cd

  carrier_types = YAML.load(open('db/fixtures/enju_biblio/carrier_types.yml').read)
  carrier_types.each do |line|
    l = line[1].select!{|k, v| %w(name display_name note).include?(k)}

    case line[1]["name"]
    when "volume"
    carrier_type = CarrierType.where(name: 'print').first
    carrier_type.update_attributes!(line[1]) if carrier_type
    when "audio_disc"
    carrier_type = CarrierType.where(name: 'cd').first
    carrier_type.update_attributes!(line[1]) if carrier_type
    when "videodisc"
    carrier_type = CarrierType.where(name: 'dvd').first
    carrier_type.update_attributes!(line[1]) if carrier_type
    when "online_resource"
    carrier_type = CarrierType.where(name: 'file').first
    carrier_type.update_attributes!(line[1]) if carrier_type
    end
  end
end
