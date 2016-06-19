    xml.title manifestation.original_title
    xml.link manifestation_url(manifestation)
    xml.description [ manifestation.publishers.join(", "), manifestation.pub_date, manifestation.description ].compact.join("; ")
