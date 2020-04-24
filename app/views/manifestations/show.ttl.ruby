graph = RDF::Graph.new

graph << RDF::Statement.new(
  RDF::URI.new(manifestation_url(@manifestation)),
  RDF::Vocab::DC.title,
  @manifestation.original_title
)

@manifestation.creators.each do |creator|
  graph << RDF::Statement.new(
    RDF::URI.new(manifestation_url(@manifestation)),
    RDF::Vocab::DC.creator,
    RDF::URI.new(profile_url(creator))
  )
end

@manifestation.publishers.each do |publisher|
  graph << RDF::Statement.new(
    RDF::URI.new(manifestation_url(@manifestation)),
    RDF::Vocab::DC.publisher,
    RDF::URI.new(profile_url(publisher))
  )
end

@manifestation.isbn_records.each do |isbn_record|
  graph << RDF::Statement.new(
    RDF::URI.new(manifestation_url(@manifestation)),
    RDF::Vocab::BIBO.isbn,
    isbn_record.body
  )
end

graph.dump(:ttl)
