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
      carrier_type = CarrierType.find_by(name: 'volume')
      if carrier_type
        carrier_type.attachment = File.open("#{File.dirname(__FILE__)}/../../app/assets/images/icons/book.png")
        carrier_type.save!
      end
    when "audio_disc"
      carrier_type = CarrierType.find_by(name: 'audio_disc')
      if carrier_type
        carrier_type.attachment = File.open("#{File.dirname(__FILE__)}/../../app/assets/images/icons/cd.png")
        carrier_type.save!
      end
    when "videodisc"
      carrier_type = CarrierType.find_by(name: 'videodisc')
      if carrier_type
        carrier_type.attachment = File.open("#{File.dirname(__FILE__)}/../../app/assets/images/icons/dvd.png")
        carrier_type.save!
      end
    when "online_resource"
      carrier_type = CarrierType.find_by(name: 'online_resource')
      if carrier_type
        carrier_type.attachment = File.open("#{File.dirname(__FILE__)}/../../app/assets/images/icons/monitor.png")
        carrier_type.save!
      end
    end
  end
end
