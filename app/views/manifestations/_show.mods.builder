    xml.titleInfo do
      xml.title manifestation.original_title
    end
    xml.titleInfo('type' => 'alternative') do
      xml.title manifestation.title_alternative
    end
    manifestation.creators.readable_by(current_user).each do |creator|
      case creator.agent_type.name
      when "person"
        xml.name('type' => 'personal') do
          xml.namePart creator.full_name
          xml.namePart creator.date if creator.date
          xml.role do
            xml.roleTerm "creator", 'type' => 'text', 'authority' => 'marcrelator'
          end
        end
      when "corporate_body"
        xml.name('type' => 'corporate') do
          xml.namePart creator.full_name
          xml.role do
            xml.roleTerm "creator", 'type' => 'text', 'authority' => 'marcrelator'
          end
        end
      when "conference"
        xml.name('type' => 'conference') do
          xml.namePart creator.full_name
          xml.role do
            xml.roleTerm "creator", 'type' => 'text', 'authority' => 'marcrelator'
          end
        end
      end
    end
    manifestation.contributors.readable_by(current_user).each do |contributor|
      case contributor.agent_type.name
      when "person"
        xml.name('type' => 'personal') do
          xml.namePart contributor.full_name
          xml.namePart contributor.date if contributor.date
        end
      when "corporate_body"
        xml.name('type' => 'corporate') do
          xml.namePart contributor.full_name
        end
      when "conference"
        xml.name('type' => 'conference') do
          xml.namePart contributor.full_name
        end
      end
    end
    xml.typeOfResource manifestation.carrier_type.mods_type
    xml.originInfo do
      manifestation.publishers.readable_by(current_user).each do |agent|
        xml.publisher agent.full_name
      end
      xml.dateIssued manifestation.date_of_publication
      xml.frequency manifestation.frequency.name
    end
    xml.language do
      xml.languageTerm manifestation.language.iso_639_2, 'authority' => 'iso639-2b', 'type' => 'code' if manifestation.language
    end
    xml.physicalDescription do
      xml.form manifestation.carrier_type.name, 'authority' => 'marcform'
      xml.extent manifestation.extent
    end
    if defined?(EnjuSubject)
      xml.subject do
        manifestation.subjects.each do |subject|
          xml.topic subject.term
        end
      end
      manifestation.classifications.each do |classification|
        xml.classification classification.category, 'authority' => classification.classification_type.name
      end
    end
    xml.abstract manifestation.description
    xml.note manifestation.note
    manifestation.identifier_contents(:isbn).each do |i|
      xml.identifier i, type: 'isbn'
    end
    manifestation.identifier_contents(:lccn).each do |l|
      xml.identifier l, type: 'lccn'
    end
    xml.recordInfo do
      xml.recordCreationDate manifestation.created_at
      xml.recordChangeDate manifestation.updated_at
      xml.recordIdentifier manifestation_url(manifestation)
    end
