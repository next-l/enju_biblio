require 'rails_helper'

describe Manifestation, solr: true do
  fixtures :all
  before do
    5.times do
      FactoryBot.create(:manifestation, :with_item, :with_subject)
    end
    Manifestation.reindex
  end

  it "should set year_of_publication" do
    manifestation = FactoryBot.create(:manifestation, pub_date: '2000')
    expect(manifestation.year_of_publication).to eq 2000
    expect(manifestation.date_of_publication).to eq Time.zone.parse('2000-01-01')
  end

  it "should set date_of_publication" do
    manifestation = FactoryBot.create(:manifestation, pub_date: '2000-01')
    expect(manifestation.year_of_publication).to eq 2000
    expect(manifestation.month_of_publication).to eq 1
    expect(manifestation.date_of_publication).to eq Time.zone.parse('2000-01-01')
  end

  it "should set volume_number" do
    manifestation = FactoryBot.create(:manifestation, volume_number_string: '第1巻', issue_number_string: '20号分冊1', edition_string: '第3版')
    expect(manifestation.volume_number).to eq 1
    expect(manifestation.issue_number).to eq 20
    expect(manifestation.edition).to eq 3
  end

  it "should search title in openurl" do
    openurl = Openurl.new({title: "プログラミング"})
    results = openurl.search
    openurl.query_text.should eq "btitle_text:プログラミング"
    results.size.should eq 7
    openurl = Openurl.new({jtitle: "テスト"})
    results = openurl.search
    results.size.should eq 3
    openurl.query_text.should eq "jtitle_text:テスト"
    openurl = Openurl.new({atitle: "2005"})
    results = openurl.search
    results.size.should eq 1
    openurl.query_text.should eq "atitle_text:2005"
    openurl = Openurl.new({atitle: "テスト", jtitle: "テスト雑誌"})
    results = openurl.search
    results.size.should eq 2
  end

  it "should search agent in openurl" do
    openurl = Openurl.new({aulast: "Administrator"})
    results = openurl.search
    openurl.query_text.should eq "au_text:Administrator"
    results.size.should eq 2
    openurl = Openurl.new({aufirst: "名称"})
    results = openurl.search
    openurl.query_text.should eq "au_text:名称"
    results.size.should eq 1
    openurl = Openurl.new({au: "テスト"})
    results = openurl.search
    openurl.query_text.should eq "au_text:テスト"
    results.size.should eq 1
    openurl = Openurl.new({pub: "Administrator"})
    results = openurl.search
    openurl.query_text.should eq "publisher_text:Administrator"
    results.size.should eq 4
  end

  it "should search isbn in openurl" do
    FactoryBot.create(:manifestation, isbn_records: [IsbnRecord.find_by(body: '4798002062')])
    FactoryBot.create(:manifestation, isbn_records: [IsbnRecord.find_by(body: '4798101028')])
    openurl = Openurl.new({api: "openurl", isbn: "4798"})
    results = openurl.search
    openurl.query_text.should eq "isbn_sm:4798*"
    results.size.should eq 2
  end

  it "should search issn in openurl" do
    FactoryBot.create(:manifestation, issn_records: [IssnRecord.find_by(body: '09130000')])
    openurl = Openurl.new({api: "openurl", issn: "0913"})
    results = openurl.search
    openurl.query_text.should eq "issn_sm:0913*"
    results.size.should eq 1
  end

  it "should search any in openurl" do
    openurl = Openurl.new({any: "テスト"})
    results = openurl.search
    results.size.should eq 9
  end

  it "should search multi in openurl" do
    openurl = Openurl.new({btitle: "CGI Perl プログラミング"})
    results = openurl.search
    results.size.should eq 2
    openurl = Openurl.new({jtitle: "テスト", pub: "テスト"})
    results = openurl.search
    results.size.should eq 2
  end

  it "shoulld get search_error in openurl" do
    lambda{Openurl.new({isbn: "12345678901234"})}.should raise_error(OpenurlQuerySyntaxError)
    lambda{Openurl.new({issn: "1234abcd"})}.should raise_error(OpenurlQuerySyntaxError)
    lambda{Openurl.new({aufirst: "テスト 名称"})}.should raise_error(OpenurlQuerySyntaxError)
  end

  it "should search in sru" do
    sru = Sru.new({query: "title=Ruby"})
    sru.search
    sru.manifestations.size.should eq 18
    sru.manifestations.first.titles.first.should eq 'Ruby'
    sru = Sru.new({query: "title=^ruby"})
    sru.search
    sru.manifestations.size.should eq 9
    sru = Sru.new({query: 'title ALL "awk sed"'})
    sru.search
    sru.manifestations.size.should eq 2
    sru.manifestations.collect{|m| m.id}.should eq [184, 116]
    sru = Sru.new({query: 'title ANY "ruby awk sed"'})
    sru.search
    sru.manifestations.size.should eq 22
    sru = Sru.new({query: 'isbn=9784756137470'})
    sru.search
    sru.manifestations.first.id.should eq 114
    sru = Sru.new({query: "creator=テスト"})
    sru.search
    sru.manifestations.size.should eq 1
  end

  it "should search date in sru" do
    sru = Sru.new({query: "from = 2000-09 AND until = 2000-11-01"})
    sru.search
    sru.manifestations.size.should eq 1
    sru.manifestations.first.id.should eq 120
    sru = Sru.new({query: "from = 1993-02-24"})
    sru.search
    sru.manifestations.size.should eq 5
    sru = Sru.new({query: "until = 2006-08-06"})
    sru.search
    sru.manifestations.size.should eq 4
  end

  it "should accept sort_by in sru" do
    sru = Sru.new({query: "title=Ruby"})
    sru.sort_by.should eq({sort_by: 'created_at', order: 'desc'})
    sru = Sru.new({query: 'title=Ruby AND sortBy="title/sort.ascending"', sortKeys: 'creator,0', version: '1.2'})
    sru.sort_by.should eq({sort_by: 'sort_title', order: 'asc'})
    sru = Sru.new({query: 'title=Ruby AND sortBy="title/sort.ascending"', sortKeys: 'creator,0', version: '1.1'})
    sru.sort_by.should eq({sort_by: 'creator', order: 'desc'})
    sru = Sru.new({query: 'title=Ruby AND sortBy="title/sort.ascending"', sortKeys: 'creator,1', version: '1.1'})
    sru.sort_by.should eq({sort_by: 'creator', order: 'asc'})
    sru = Sru.new({query: 'title=Ruby AND sortBy="title'})
    sru.sort_by.should eq({sort_by: 'sort_title', order: 'asc'})
    # TODO ソート基準が入手しやすさの場合の処理
  end

  it "should accept ranges in sru" do
    sru = Sru.new({query: "from = 1993-02-24 AND until = 2006-08-06 AND title=プログラミング"})
    sru.search
    sru.manifestations.size.should eq 2
    sru = Sru.new({query: "until = 2000 AND title=プログラミング"})
    sru.search
    sru.manifestations.size.should eq 1
    sru = Sru.new({query: "from = 2006 AND title=プログラミング"})
    sru.search
    sru.manifestations.size.should eq 1
    sru = Sru.new({query: "from = 2007 OR title=awk"})
    sru.search
    sru.manifestations.size.should eq 6
  end

  describe "Default manifestation" do
    subject(:manifestation) { FactoryBot.create(:manifestation, start_page: 101, end_page: 200) }

    it "should_get_number_of_pages" do
      expect(manifestation.number_of_pages).to eq 100
    end

    it "should have parent_of_series" do
      expect(manifestation.parent_of_series).to be_truthy
    end

    it "should respond to extract_text" do
      expect(manifestation.extract_text).to be_nil
    end

    it "should respond to title" do
      expect(manifestation.title).to be_truthy
    end
  end

  it "should respond to pickup" do
    lambda{Manifestation.pickup}.should_not raise_error # (ActiveRecord::RecordNotFound)
  end

  describe "Periodocal manifestation" do
    subject(:manifestation) { 
      FactoryBot.create(
        :manifestation,
        serial: true,
        series_statements: [FactoryBot.create(:series_statement)]
      )
    }

    it "should be periodical if its series_statement is periodical" do
      expect(manifestation.serial?).to be_truthy
    end

    it "should validate access_address" do
      manifestation.access_address = 'http:/www.example.jp'
      manifestation.should_not be_valid
    end
  end

  # it "should set series_statement if the manifestation is periodical" do
  #  manifestation = series_statements(:two).manifestations.new
  #  manifestation.set_series_statements([series_statements(:two)])
  #  #manifestation.original_title.should eq 'テスト雑誌２月号'
  #  #manifestation.serial_number.should eq 3
  #  #manifestation.issue_number.should eq 3
  #  #manifestation.volume_number.should eq 1
  # end

  context ".export" do
    it "should export a header line" do
      lines = Manifestation.export
      csv = CSV.parse(lines, headers: true, col_sep: "\t")
      csv["manifestation_id"].compact.should_not be_empty
      csv["manifestation_identifier"].compact.should_not be_empty
      csv["manifestation_created_at"].compact.should_not be_empty
      csv["manifestation_updated_at"].compact.should_not be_empty
      csv["item_id"].compact.should_not be_empty
      csv["item_created_at"].compact.should_not be_empty
      csv["item_updated_at"].compact.should_not be_empty
      csv["subject:unknown"].compact.inject(0){|count, a| count += 1 if a == 'next-l'; count}.should eq manifestations(:manifestation_00001).items.count
      csv["classification:ndc9"].compact.inject(0){|count, a| count += 1 if a == '400'; count}.should eq manifestations(:manifestation_00001).items.count
      csv["extent"].compact.should_not be_empty
      csv["dimensions"].compact.should_not be_empty
    end

    it "should export edition fields" do
      manifestation = FactoryBot.create(:manifestation, edition: 2, edition_string: "Revised Ed.")
      lines = Manifestation.export
      csv = CSV.parse(lines, headers: true, col_sep: "\t")
      expect(csv["edition"].compact).not_to be_empty
      expect(csv["edition_string"].compact).not_to be_empty
      m = csv.find{|row| row["manifestation_id"].to_i == manifestation.id }
      expect(m["edition"]).to eq "2"
      expect(m["edition_string"]).to eq "Revised Ed."
    end

    it "should export title_transcription fields" do
      manifestation = FactoryBot.create(:manifestation, title_transcription: "Transcripted title")
      lines = Manifestation.export
      csv = CSV.parse(lines, headers: true, col_sep: "\t")
      expect(csv["title_transcription"].compact).not_to be_empty
      m = csv.find{|row| row["manifestation_id"].to_i == manifestation.id }
      expect(m["title_transcription"]).to eq "Transcripted title"
    end

    it "should export volume fields" do
      manifestation = FactoryBot.create(:manifestation, volume_number: 15, volume_number_string: "Vol.15")
      lines = Manifestation.export
      csv = CSV.parse(lines, headers: true, col_sep: "\t")
      expect(csv["volume_number"].compact).not_to be_empty
      expect(csv["volume_number_string"].compact).not_to be_empty
      m = csv.find{|row| row["manifestation_id"].to_i == manifestation.id }
      expect(m["volume_number"]).to eq "15"
      expect(m["volume_number_string"]).to eq "Vol.15"
    end

    it "should export multiple identifiers" do
      manifestation = FactoryBot.create(:manifestation)
      isbn_type = IdentifierType.where(name: :isbn).first
      manifestation.identifiers << FactoryBot.create(:identifier, body: "978-4043898039", identifier_type: isbn_type)
      manifestation.identifiers << FactoryBot.create(:identifier, body: "978-4840239219", identifier_type: isbn_type)
      lines = Manifestation.export()
      csv = CSV.parse(lines, headers: true, col_sep: "\t")
      m = csv.find{|row| row["manifestation_id"].to_i == manifestation.id }
      expect(m["identifier:isbn"]).to eq "9784043898039//9784840239219"
    end

    it "should respect the role of the user" do
      FactoryBot.create(:item, bookstore_id: 1, price: 100, budget_type_id: 1)
      lines = Manifestation.export(role: 'Guest')
      csv = CSV.parse(lines, headers: true, col_sep: "\t")
      expect(csv["bookstore"].compact).to be_empty
      expect(csv["item_price"].compact).to be_empty
      expect(csv["budget_type"].compact).to be_empty

      lines = Manifestation.export(role: 'Librarian')
      csv = CSV.parse(lines, headers: true, col_sep: "\t")
      expect(csv["bookstore"].compact).not_to be_empty
      expect(csv["item_price"].compact).not_to be_empty
      expect(csv["budget_type"].compact).not_to be_empty
    end

    it 'should escape LF/CR to "\n"' do
      manifestation = FactoryBot.create(:manifestation, description: "test\ntest", note: "test\ntest")
      item = FactoryBot.create(:item, manifestation: manifestation, note: "test\ntest")
      lines = Manifestation.export
      csv = CSV.parse(lines, headers: true, col_sep: "\t")
      expect(csv["description"].compact).not_to be_empty
      expect(csv["note"].compact).not_to be_empty
      expect(csv["item_note"].compact).not_to be_empty
      m = csv.find{|row| row["manifestation_id"].to_i == manifestation.id }
      expect(m["description"]).to eq "test\ntest"
      expect(m["note"]).to eq "test\ntest"
      expect(m["item_note"]).to eq "test\ntest"
    end

    it 'should export custom properties"' do
      item = FactoryBot.create(:item)
      item.item_custom_values << FactoryBot.build(:item_custom_value)
      item.manifestation.manifestation_custom_values << FactoryBot.build(:manifestation_custom_value)
      lines = Manifestation.export(role: 'Librarian')
      csv = CSV.parse(lines, headers: true, col_sep: "\t")
      m = csv.find{|row| row["manifestation_id"].to_i == item.manifestation.id }
      item.item_custom_values.each do |custom_value|
        expect(m["item:#{custom_value.item_custom_property.name}"]).to eq custom_value.value
      end
      item.manifestation.manifestation_custom_values.each do |custom_value|
        expect(m["manifestation:#{custom_value.manifestation_custom_property.name}"]).to eq custom_value.value
      end
    end
  end
end

# == Schema Information
#
# Table name: manifestations
#
#  id                              :bigint           not null, primary key
#  original_title                  :text             not null
#  title_alternative               :text
#  title_transcription             :text
#  manifestation_identifier        :string
#  date_copyrighted                :datetime
#  date_of_publication             :datetime
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#  access_address                  :string
#  language_id                     :integer          default(1), not null
#  carrier_type_id                 :integer          default(1), not null
#  start_page                      :integer
#  end_page                        :integer
#  height                          :integer
#  width                           :integer
#  depth                           :integer
#  price                           :integer
#  fulltext                        :text
#  volume_number_string            :string
#  issue_number_string             :string
#  serial_number_string            :string
#  edition                         :integer
#  note                            :text
#  repository_content              :boolean          default(FALSE), not null
#  lock_version                    :integer          default(0), not null
#  required_role_id                :integer          default(1), not null
#  required_score                  :integer          default(0), not null
#  frequency_id                    :integer          default(1), not null
#  subscription_master             :boolean          default(FALSE), not null
#  title_alternative_transcription :text
#  description                     :text
#  abstract                        :text
#  available_at                    :datetime
#  valid_until                     :datetime
#  date_submitted                  :datetime
#  date_accepted                   :datetime
#  date_captured                   :datetime
#  pub_date                        :string
#  edition_string                  :string
#  volume_number                   :integer
#  issue_number                    :integer
#  serial_number                   :integer
#  content_type_id                 :integer          default(1)
#  year_of_publication             :integer
#  month_of_publication            :integer
#  fulltext_content                :boolean
#  serial                          :boolean
#  statement_of_responsibility     :text
#  publication_place               :text
#  extent                          :text
#  dimensions                      :text
#  memo                            :text
#  license_id                      :bigint           default(1), not null
#
