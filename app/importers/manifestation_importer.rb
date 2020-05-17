class ManifestationImporter
  include ActiveModel::Model

  attr_accessor :manifestation_identifier, :manifestation_id,
    :original_title, :access_address, :note, :memo,
    :title_transcription,
    :abstract, :description,
    :serial,
    :carrier_type, :content_type, :language, :frequency, :manifestation_required_role, :item_required_role,
    :volume_number, :volume_number_string,
    :issue_number, :issue_number_string,
    :edition, :edition_string, :serial_number,
    :publication_place,
    :manifestation_price, :series_original_title,
    :budget_type, :bookstore,
    :isbn, :issn, :access_address, :doi, :jpno, :ndl_bib_id,
    :statement_of_responsibility, :extent, :dimensions,
    :height, :width, :depth,
    :start_page, :end_page,
    :creator, :creator_transcription,
    :contributor, :contributor_transcription,
    :publisher, :publisher_transcription, :pub_date,
    :subjects, :classifications,
    :item_identifier, :item_id, :binding_item_identifier, :call_number, :binding_call_number, :binded_at,
    :shelf, :default_shelf, :item_price, :item_note, :include_supplements, :item_url, :acquired_at,
    :dummy,
    :action, :manifestation_record, :item_record, :manifestation_result, :item_result, :error_message, :row

  def self.create_entry(row, **options)
    ManifestationImporter.new(
      manifestation_identifier: row['manifestation_identifier'],
      manifestation_id: row['manifestation_id'],
      item_identifier: row['item_identifier'],
      item_id: row['item_id'],
      binding_item_identifier: row['binding_item_identifier'],
      call_number: row['call_number'],
      binding_call_number: row['binding_call_number'],
      binded_at: row['binded_at'],
      shelf: row['shelf'],
      default_shelf: options[:default_shelf],
      original_title: row['original_title'],
      title_transcription: row['title_transcription'],
      serial: row['serial'],
      carrier_type: row['carrier_type'],
      content_type: row['content_type'],
      language: row['language'],
      frequency: row['frequency'],
      manifestation_required_role: row['manifestation_required_role'],
      item_required_role: row['item_required_role'],
      volume_number: row['volume_number'],
      volume_number_string: row['volume_number_string'],
      issue_number: row['issue_number'],
      issue_number_string: row['issue_number_string'],
      edition: row['edition'],
      edition_string: row['edition_string'],
      serial_number: row['serial_number'],
      statement_of_responsibility: row['statement_of_responsibility'],
      series_original_title: row['series_original_title'],
      extent: row['extent'],
      dimensions: row['dimensions'],
      height: row['height'],
      width: row['width'],
      depth: row['depth'],
      start_page: row['start_page'],
      end_page: row['end_page'],
      pub_date: row['pub_date'],
      publication_place: row['publication_place'],
      manifestation_price: row['manifestation_price'],
      isbn: row['isbn'],
      issn: row['issn'],
      ndl_bib_id: row['ndl_bib_id'],
      doi: row['doi'],
      access_address: row['access_address'],
      abstract: row['abstract'].try(:gsub, /\\n/, "\n"),
      description: row['description'].try(:gsub, /\\n/, "\n"),
      note: row['note'].try(:gsub, /\\n/, "\n"),
      item_note: row['item_note'].try(:gsub, /\\n/, "\n"),
      memo: row['memo'].try(:gsub, /\\n/, "\n"),
      creator: row['creator'],
      creator_transcription: row['creator_transcription'],
      contributor: row['contributor'],
      contributor_transcription: row['contributor_transcription'],
      publisher: row['publisher'],
      publisher_transcription: row['publisher_transcription'],
      acquired_at: row['acquired_at'],
      item_price: row['item_price'],
      item_url: row['item_url'],
      include_supplements: row['include_supplements'],
      budget_type: row['budget_type'],
      bookstore: row['bookstore'],
      dummy: row['dummy'],
      action: options[:action]
    )
  end

  def self.import(csv, **options)
    entries = []
    CSV.foreach(csv, encoding: 'UTF-8', headers: true, col_sep: "\t") do |row|

      entry = self.create_entry(row, options)

      if entry.dummy.present?
        entry.manifestation_result = :skipped
        entry.item_result = :skipped
      else
        entry.import

        if entry.manifestation_record&.valid?
          if [:created, :updated].include?(entry.manifestation_result)
            series_statements = import_series_statement(row)
            entry.manifestation_record.series_statements = series_statements unless series_statements.empty?
            entry.manifestation_record.reload

            subjects = import_subject(row)
            entry.manifestation_record.subjects = subjects unless subjects.empty?
            entry.manifestation_record.reload

            classifications = import_classification(row)
            entry.manifestation_record.classifications = classifications unless classifications.empty?
            entry.manifestation_record.reload

            import_manifestation_custom_value(row, entry.manifestation_record).each do |value|
              value.update!(manifestation: entry.manifestation_record)
            end
          end

          if [:created, :updated].include?(entry.item_result)
            import_item_custom_value(row, entry.item_record).each do |value|
              value.update!(item: entry.item_record)
            end
          end
        end
      end

      entries << entry
    end

    entries
  end

  def import
    return if dummy.present?
    case action
    when 'create'
      create
    when 'update'
      update
    when 'destroy'
      destroy
    else
      raise 'Invalid action'
    end
  end

  private

  def create
    imported = false
    self.manifestation_record = find_by_manifestation_identifier || find_by_item_identifier || find_by_item_id
    self.manifestation_record = find_by_jpno || find_by_doi || find_by_isbn unless manifestation_record
    
    if manifestation_record
      self.manifestation_result = :found
    else
      begin
        self.manifestation_record = import_by_ndl_bib_id || import_by_isbn
        imported = true if manifestation_record&.valid?
      rescue => e
        self.error_message = e
      end
    end

    if manifestation_record&.valid?
      # 新しくインポートされた書誌はID以外をTSVファイルで上書きする
      if imported
        update_manifestation
        import_creator
        import_publisher
        #import_isbn
        #import_issn
        #import_doi
      end
    else
      create_manifestation
      if manifestation_record.valid?
        import_creator
        import_publisher
        import_isbn
        import_issn
        import_doi
      end
    end

    if manifestation_record.valid?
      item_importer = ItemImporter.new(
        manifestation: manifestation_record,
        shelf: shelf || default_shelf,
        item_identifier: item_identifier,
        binding_item_identifier: binding_item_identifier,
        call_number: call_number,
        binding_call_number: binding_call_number,
        binded_at: binded_at,
        acquired_at: acquired_at,
        price: item_price,
        budget_type: budget_type,
        bookstore: bookstore,
        required_role: item_required_role,
        note: item_note,
        include_supplements: include_supplements,
        url: item_url,
        action: action
      ).import

      self.manifestation_result = :created unless manifestation_result
      self.item_record = item_importer&.record
      self.item_result = item_importer&.result
    else
      self.error_message = manifestation_record&.errors&.full_messages unless error_message
      self.manifestation_result = :failed
      self.item_result = :failed
    end

    self
  end

  def update
    self.manifestation_record = find_by_manifestation_identifier || find_by_item_identifier || find_by_item_id || find_by_jpno || find_by_doi || find_by_isbn

    manifestation_record.original_title = original_title if original_title.present?
    update_manifestation

    if manifestation_record.valid?
      import_isbn
      import_issn
      import_creator
      import_publisher
      import_doi
      self.manifestation_result = :updated

      item_importer = ItemImporter.new(
        manifestation: manifestation_record,
        shelf: shelf || default_shelf,
        item_identifier: item_identifier,
        binding_item_identifier: binding_item_identifier,
        call_number: call_number,
        binding_call_number: binding_call_number,
        binded_at: binded_at,
        acquired_at: acquired_at,
        price: item_price,
        budget_type: budget_type,
        bookstore: bookstore,
        required_role: item_required_role,
        note: item_note,
        include_supplements: include_supplements,
        url: item_url,
        action: action
      )

      if item_importer.import
        self.item_record = item_importer.record
        self.item_result = item_importer.result
      end
    else
      self.manifestation_result = :failed
    end

    self
  end

  def destroy
    item = nil
    item = Item.find_by(item_identifier: item_identifier.strip) if item_identifier.present?
    manifestation = item&.manifestation || find_by_manifestation_identifier

    if item.removable?
      item.donates.destroy_all
      if item.destroy
        self.manifestation_result = :destroyed
      end
    end

    if manifestation.items.empty?
      if manifestation&.destroy
        self.manifestation_result = :destroyed
      end
    end

    self
  end

  def find_by_manifestation_identifier
    manifestation = nil
    if manifestation_identifier.present?
      manifestation = Manifestation.find_by(manifestation_identifier: manifestation_identifier.strip)
    end

    unless manifestation
      manifestation = Manifestation.find_by(id: manifestation_id.strip) if manifestation_id.present?
    end

    manifestation
  end

  def find_by_item_identifier
    Item.find_by(item_identifier: item_identifier.strip)&.manifestation if item_identifier
  end

  def find_by_item_id
    Item.find_by(id: item_id.strip)&.manifestation if item_id
  end

  def find_by_isbn
    return if isbn.blank?
    manifestation = nil

    isbn.split('//').each do |i|
      next if i.blank?
      isbn10_body = Lisbn.new(i).isbn10
      isbn13_body = Lisbn.new(i).isbn13
      manifestation = IsbnRecord.find_by(body: isbn10_body)&.manifestations&.first
      manifestation = IsbnRecord.find_by(body: isbn13_body)&.manifestations&.first unless manifestation
      next manifestation if manifestation
    end

     manifestation
  end

  def import_creator
    return if creator.blank?
    manifestation_record.creates.destroy_all
    creator.split('//').each_with_index do |n, i|
      name_and_role = n.split('||')
      agent = Agent.find_or_initialize_by(full_name: name_and_role[0].strip)
      agent.full_name_transcription = creator_transcription.split('//')[i] if creator_transcription
      agent.save!
      manifestation_record.reload
      Create.create!(
        work: manifestation_record,
        agent: agent,
        create_type: CreateType.find_by(name: name_and_role[1]) || CreateType.order(:position).first
      )
    end
  end

  def import_publisher
    return if publisher.blank?
    manifestation_record.produces.destroy_all
    publisher.split('//').each_with_index do |n, i|
      name_and_role = n.split('||')
      agent = Agent.find_or_initialize_by(full_name: name_and_role[0])
      agent.full_name_transcription = publisher_transcription.split('//')[i] if publisher_transcription
      agent.save!
      manifestation_record.reload
      Produce.create!(
        manifestation: manifestation_record,
        agent: agent,
        produce_type: ProduceType.find_by(name: name_and_role[1]) || ProduceType.order(:position).first
      )
    end
  end

  def import_isbn
    return if isbn.blank?

    manifestation_record.isbn_record_and_manifestations.destroy_all
    isbn.split('//').each do |i|
      isbn_body = Lisbn.new(i).isbn13
      IsbnRecordAndManifestation.create(
        manifestation: manifestation_record,
        isbn_record: IsbnRecord.find_or_create_by!(body: isbn_body)
      ) if isbn_body
    end
  end

  def import_issn
    return if issn.blank?

    manifestation_record.issn_record_and_manifestations.destroy_all
    issn.split('//').each do |i|
      issn_body = StdNum::ISSN.normalize(i)
      IssnRecordAndManifestation.create(
        manifestation: manifestation_record,
        issn_record: IssnRecord.find_or_create_by!(body: issn_body)
      ) if issn_body
    end
  end

  def import_doi
    return if doi.blank?

    doi_record = DoiRecord.find_or_initialize_by(body: doi.downcase)
    doi_record.update!(manifestation: manifestation_record, display_body: doi)
  end

  def import_by_isbn
    return if isbn.blank?

    manifestation = nil
    isbn.split('//').each do |i|
      manifestation = Manifestation.import_isbn(i)
      next manifestation if manifestation
    end

    manifestation
  end

  def import_by_ndl_bib_id
    return if ndl_bib_id.blank?
    Manifestation.import_ndl_bib_id(ndl_bib_id)
  end

  def find_by_doi
    return if doi.blank?
    identifier_type_doi = IdentifierType.find_by(name: 'doi')
    return unless identifier_type_doi

    doi_body = URI.parse(row['doi']).path.gsub(/^\//, "")
    Identifier.find_by(body: doi_body.downcase, identifier_type: identifier_type_doi).manifestation
  end

  def find_by_jpno
    return if jpno.blank?
    identifier_type_jpno = IdentifierType.find_by(name: 'jpno')
    return unless identifier_type_jpno

    Identifier.find_by(body: jpno_body.downcase, identifier_type: identifier_type_jpno).manifestation
  end


  def create_manifestation
    self.manifestation_record = Manifestation.create(
      manifestation_identifier: manifestation_identifier,
      original_title: original_title,
      title_transcription: title_transcription,
      abstract: abstract,
      description: description,
      serial: serial,
      volume_number: volume_number,
      volume_number_string: volume_number_string,
      issue_number: issue_number,
      issue_number_string: issue_number_string,
      edition: edition,
      edition_string: edition_string,
      serial_number: serial_number,
      access_address: access_address,
      pub_date: pub_date,
      publication_place: publication_place,
      statement_of_responsibility: statement_of_responsibility,
      extent: extent,
      dimensions: dimensions,
      height: height,
      width: width,
      depth: depth,
      start_page: start_page,
      end_page: end_page,
      price: manifestation_price,
      carrier_type: CarrierType.find_by(name: carrier_type) || CarrierType.order(:position).first,
      manifestation_content_type: ContentType.find_by(name: content_type) || ContentType.order(:position).first,
      language: Language.find_by(name: language) || Language.order(:position).first,
      frequency: Frequency.find_by(name: frequency) || Frequency.find_by(name: 'unknown'),
      required_role: Role.find_by(name: manifestation_required_role) || Role.find_by(name: 'Librarian'),
      note: note,
      memo: memo
    )
  end

  def update_manifestation
    attributes = {
      manifestation_identifier: manifestation_identifier,
      original_title: original_title,
      title_transcription: title_transcription,
      abstract: abstract,
      description: description,
      serial: serial,
      volume_number: volume_number,
      volume_number_string: volume_number_string,
      issue_number: issue_number,
      issue_number_string: issue_number_string,
      edition: edition,
      edition_string: edition_string,
      serial_number: serial_number,
      access_address: access_address,
      pub_date: pub_date,
      publication_place: publication_place,
      statement_of_responsibility: statement_of_responsibility,
      extent: extent,
      dimensions: dimensions,
      height: height,
      width: width,
      depth: depth,
      start_page: start_page,
      end_page: end_page,
      price: manifestation_price,
      note: note,
      memo: memo
    }

    manifestation_record.update(attributes.compact)

    manifestation_record.update(original_title: original_title) if original_title
    manifestation_record.update(manifestation_identifier: manifestation_identifier) if manifestation_identifier
    manifestation_record.update(carrier_type: CarrierType.find_by(name: carrier_type)) if carrier_type
    manifestation_record.update(manifestation_content_type: ContentType.find_by(name: content_type)) if content_type
    manifestation_record.update(language: Language.find_by(name: language)) if language
    manifestation_record.update(frequency: Frequency.find_by(name: frequency)) if frequency
    manifestation_record.update(required_role: Role.find_by(name: manifestation_required_role)) if manifestation_required_role
  end

  def self.import_subject(row)
    subjects = []
    SubjectHeadingType.order(:position).pluck(:name).map{|s| "subject:#{s}"}.each do |column_name|
      type = column_name.split(':').last
      subject_list = row[column_name].to_s.split('//')
      subject_list.map{|value|
        subject_heading_type = SubjectHeadingType.find_by(name: type)
        next unless subject_heading_type
        subject = Subject.new(term: value)
        subject.subject_heading_type = subject_heading_type
        # TODO: Subject typeの設定
        subject.subject_type = SubjectType.find_by(name: 'concept')
        subject.save!
        subjects << subject
      }
    end

    subjects
  end

  def self.import_classification(row)
    classifications = []
    ClassificationType.order(:position).pluck(:name).map{|c| "classification:#{c}"}.each do |column_name|
      type = column_name.split(':').last
      classification_list = row[column_name].to_s.split('//')
      classification_list.map{|value|
        classification_type = ClassificationType.find_by(name: type)
        next unless classification_type
        classification = Classification.new(category: value)
        classification.classification_type = classification_type
        classification.save!
        classifications << classification
      }
    end

    classifications
  end

  def self.import_series_statement(row)
    series_statements = []
    if row['series_original_title']
      series_statement = SeriesStatement.new(
        original_title: row['series_original_title'],
        title_transcription: row['series_title_transcription'],
        title_subseries: row['series_title_subseries'],
        title_subseries_transcription: row['series_title_subseries_transcription'],
        volume_number_string: row['series_volume_number_string'],
        creator_string: row['series_creator_string'],
      )
      series_statement.save!
      series_statements << series_statement
    end

    series_statements
  end

  def self.import_manifestation_custom_value(row, manifestation)
    values = []
    ManifestationCustomProperty.order(:position).pluck(:name).map{|c| "manifestation:#{c}"}.each do |column_name|
      value = nil
      property = column_name.split(':').last
      next if row[column_name].blank?
      if manifestation
        value = manifestation.manifestation_custom_values.find_by(manifestation_custom_property: property)
      end

      if value
        value.value = row[column_name]
      else
        value = ManifestationCustomValue.new(
          manifestation_custom_property: ManifestationCustomProperty.find_by(name: property),
          value: row[column_name]
        )
      end
      values << value
    end
    values
  end

  def self.import_item_custom_value(row, item)
    values = []
    ItemCustomProperty.order(:position).pluck(:name).map{|c| "item:#{c}"}.each do |column_name|
      value = nil
      property = column_name.split(':').last
      next if row[column_name].blank?
      if item
        value = item.item_custom_values.find_by(item_custom_property: property)
      end

      if value
        value.value = row[column_name]
      else
        value = ItemCustomValue.new(
          item_custom_property: ItemCustomProperty.find_by(name: property),
          value: row[column_name]
        )
      end
      values << value
    end
    values
  end
end
