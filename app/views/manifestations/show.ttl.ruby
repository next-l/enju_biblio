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
    creator
  )
end

@manifestation.publishers.each do |publisher|
  graph << RDF::Statement.new(
    RDF::URI.new(manifestation_url(@manifestation)),
    RDF::Vocab::DC.publisher,
    publisher
  )
end

graph.dump(:ttl)
