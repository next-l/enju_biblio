def update_identifier_type
  identifier_types = YAML.load(open('db/fixtures/enju_biblio/identifier_types.yml').read)
  identifier_types.each do |line|
    l = line[1].select!{|k, v| %w(name display_name note).include?(k)}
    identifier_type = IdentifierType.where(name: l["name"]).first
    if identifier_type
      identifier_type.update_attributes!(l)
    else
      IdentifierType.create!(l)
    end
  end
end
