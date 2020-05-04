require 'rails_helper'
  
describe ResourceImportFile do
  fixtures :all
  
  describe "when its mode is 'create'" do
    describe "when it is written in utf-8" do
      before(:each) do
        @file = ResourceImportFile.new(
          user: users(:admin),
          default_shelf_id: 3,
          edit_mode: 'create'
        )
        @file.resource_import.attach(io: File.new("#{Rails.root}/../../examples/resource_import_file_sample1.tsv"), filename: 'attachment.txt')
        @file.save
        @old_message_count = Message.count
        @old_manifestations_count = Manifestation.count
        @old_items_count = Item.count
        @old_agents_count = Agent.count
        @old_import_results_count = ResourceImportResult.count
        @result = @file.import_start
      end

      it "should be imported", vcr: true do
        expect(@result).to eq({
          manifestation_created: 9, manifestation_found: 10, manifestation_updated: 0, manifestation_failed: 1, manifestation_skipped: 2,
          item_created: 16, item_found: 3, item_updated: 0, item_failed: 1, item_skipped: 2
        })
        expect(Manifestation.count).to eq @old_manifestations_count + 9
        expect(Item.count).to eq @old_items_count + 16
        expect(Agent.count).to eq @old_agents_count + 8
        expect(ResourceImportResult.count).to eq @old_import_results_count + 22
      end

      it "should import item 11111", vcr: true do
        item = Item.find_by(item_identifier: '11111')
        manifestation = item.manifestation
        expect(manifestation.publishers.first.full_name).to eq 'test4'
        expect(manifestation.publishers.first.full_name_transcription).to eq 'てすと4'
        expect(manifestation.publishers.second.full_name_transcription).to eq 'てすと5'
        expect(manifestation.produces.first.produce_type.name).to eq 'publisher'
        expect(manifestation.creates.first.create_type.name).to eq 'author'
        expect(manifestation.issn_records.pluck(:body)).to eq ['03875806']
        expect(item.shelf.name).to eq 'second_shelf'
        expect(item.manifestation.price).to eq 1000
        expect(item.price).to eq 0
        expect(item.manifestation.publishers.count).to eq 2
      end

      it "should import series_statements", vcr: true do
        manifestation_101 = Manifestation.find_by(manifestation_identifier: '101')
        expect(manifestation_101.series_statements.count).to eq 1
        expect(manifestation_101.series_statements.first.original_title).to eq '主シリーズ'
        expect(manifestation_101.series_statements.first.title_transcription).to eq 'しゅしりーず'
        expect(manifestation_101.series_statements.first.title_subseries).to eq '副シリーズ'
        expect(manifestation_101.series_statements.first.title_subseries_transcription).to eq 'ふくしりーず'
        expect(manifestation_101.items.order(:id).last.call_number).to eq '007|A'
        expect(manifestation_101.serial).to be_falsy
        #ResourceImportResult.where(manifestation_id: manifestation_101.id).order(:id).last.error_message.should eq "line 22: #{I18n.t('import.manifestation_found')}"
      end

      it "should import item 10101", vcr: true do
        item_10101 = Item.find_by(item_identifier: '10101')
        expect(item_10101.manifestation.creators.count).to eq 2
        expect(item_10101.manifestation.creates.order(:id).first.create_type.name).to eq 'author'
        expect(item_10101.manifestation.creates.order(:id).second.agent.full_name).to eq 'test1'
        expect(item_10101.manifestation.creates.order(:id).second.create_type.name).to eq 'illustrator'
        expect(item_10101.manifestation.date_of_publication).to eq Time.zone.parse('2001-01-01')
        expect(item_10101.budget_type.name).to eq 'Public fund'
        expect(item_10101.bookstore.name).to eq 'Example store'
        expect(item_10101.manifestation.language.name).to eq 'unknown'
        expect(item_10101.manifestation.statement_of_responsibility).to eq '著者A; 著者B'
        expect(item_10101.binding_item_identifier).to eq '9001'
        expect(item_10101.binding_call_number).to eq '330|A'
        expect(item_10101.binded_at).to eq Time.zone.parse('2014-08-16')
        expect(item_10101.manifestation.publication_place).to eq '東京'
        expect(item_10101.include_supplements).to eq true
        expect(item_10101.note).to eq 'カバーなし'
        expect(item_10101.url).to eq 'http://example.jp/item/1'
        expect(item_10101.manifestation.carrier_type.name).to eq 'volume'
        expect(item_10101.manifestation.manifestation_content_type.name).to eq 'text'
        expect(item_10101.manifestation.frequency.name).to eq 'monthly'
        expect(item_10101.manifestation.extent).to eq 'xv, 213 pages'
        expect(item_10101.manifestation.dimensions).to eq '20cm'
        #ResourceImportResult.where(item_id: item_10101.id).order(:id).last.error_message.should eq "line 9: #{I18n.t('import.item_found')}"
      end

      it "should import item 10102", vcr: true do
        item_10102 = Item.find_by(item_identifier: '10102')
        expect(item_10102.manifestation.date_of_publication).to eq Time.zone.parse('2001-01-01')
        expect(item_10102.manifestation.language.name).to eq 'Japanese'
        expect(item_10102.manifestation.height).to eq 257
        expect(item_10102.manifestation.width).to eq 182
        expect(item_10102.manifestation.depth).to eq 12
        expect(item_10102.manifestation.start_page).to eq 1
        expect(item_10102.manifestation.end_page).to eq 200
        expect(item_10102.manifestation.series_statements.first.creator_string).to eq 'シリーズの著者'
        expect(item_10102.manifestation.series_statements.first.volume_number_string).to eq 'シリーズ1号'
      end

      it "should import item 11111", vcr: true do
        Manifestation.find_by(manifestation_identifier: '103').original_title.should eq 'ダブル"クォート"を含む資料'
        item = Item.find_by(item_identifier: '11111')
        expect(item.shelf.name).to eq Shelf.find(3).name
        expect(item.manifestation.price).to eq 1000
        expect(item.price).to eq 0
        expect(item.manifestation.publishers.count).to eq 2
      end

      it "should import item 10104", vcr: true do
        item_10104 = Item.find_by(item_identifier: '10104')
        expect(item_10104.manifestation.date_of_publication).to eq Time.zone.parse('2001-01-01')
        expect(item_10104.budget_type.name).to eq 'Public fund'
        expect(item_10104.bookstore).to be_nil
        expect(item_10104.call_number).to eq '007|A'
        expect(item_10104.manifestation.carrier_type.name).to eq 'online_resource'
        expect(item_10104.manifestation.manifestation_content_type.name).to eq 'still_image'
        expect(item_10104.manifestation.frequency.name).to eq 'unknown'
        expect(item_10104.manifestation.volume_number_string).to eq '第3巻'
        expect(item_10104.manifestation.volume_number).to eq 3
        expect(item_10104.manifestation.issue_number_string).to eq '第10号'
        expect(item_10104.manifestation.issue_number).to eq 10
        expect(item_10104.manifestation.edition_string).to eq '初版'
        expect(item_10104.manifestation.edition).to eq 1
        expect(item_10104.manifestation.serial_number).to eq 120
        expect(item_10104.manifestation.doi_record.body).to eq '10.5555/example/2014.08.18'
        expect(item_10104.manifestation.height).to be_nil
        expect(item_10104.manifestation.width).to be_nil
        expect(item_10104.manifestation.depth).to be_nil
      end

      it "should import subjects", vcr: true do
        item_10101 = Item.find_by(item_identifier: '10101')
        expect(item_10101.manifestation.classifications.count).to eq 1
        expect(item_10101.manifestation.classifications.first.classification_type.name).to eq 'ndc9'
        expect(item_10101.manifestation.classifications.first.category).to eq '007'

        item_10104 = Item.find_by(item_identifier: '10104')
        expect(item_10104.manifestation.subjects.order(:id).map{|s| {s.subject_heading_type.name => s.term}}).to eq [{"ndlsh" => "コンピュータ"}, {"ndlsh" => "図書館"}]
        expect(item_10104.manifestation.classifications.order(:id).map{|c| {c.classification_type.name => c.category}}).to eq [{"ndc9" => "007"}, {"ddc" => "003"}, {"ddc" => "004"}]
      end

      it "should import manifestation 104 and 105", vcr: true do
        manifestation_104 = Manifestation.find_by(manifestation_identifier: '104')
        manifestation_105 = Manifestation.find_by(manifestation_identifier: '105')
        expect(manifestation_104.isbn_records.pluck(:body)).to eq ['9784797327038']
        expect(manifestation_104.original_title).to eq 'test10'
        expect(manifestation_104.creators.pluck(:full_name)).to eq ['test3']
        expect(manifestation_104.publishers.collect(&:full_name)).to eq ['test4']
        expect(manifestation_105.serial).to be_truthy
      end

      it "should import item 10103", vcr: true do
        item_10103 = Item.find_by(item_identifier: '10103')
        expect(item_10103.budget_type).to be_nil
        expect(item_10103.bookstore.name).to eq 'Example store'
      end

      it "should import custom values", vcr: true do
        item_10102 = Item.find_by(item_identifier: '10102')
        expect(item_10102.manifestation.manifestation_custom_values.pluck(:value)).to eq ['カスタム項目テスト1', 'カスタム項目テスト2']
        expect(item_10102.item_custom_values.pluck(:value)).to eq []
        item_10103 = Item.find_by(item_identifier: '10103')
        expect(item_10103.manifestation.manifestation_custom_values.pluck(:value)).to eq []
        expect(item_10103.item_custom_values.pluck(:value)).to eq ['カスタム項目テスト3', 'カスタム項目テスト4']
      end

      it "should generate results", vcr: true do
        expect(Item.find_by(item_identifier: '11113').manifestation.original_title).to eq 'test10'
        expect(Item.find_by(item_identifier: '11114').manifestation.id).to eq 1

        # @file.resource_import_fingerprint.should be_truthy
        #@file.resource_import_results.order(:id).first.body.split("\t").first.should eq 'imported_manifestation_id'
        expect(@file.executed_at).to be_truthy

        #@file.reload
        #@file.error_message.should eq "The following column(s) were ignored: invalid"
      end

      it "should send message when import is completed", vcr: true do
        expect(Message.count).to eq @old_message_count + 1
        expect(Message.order(:created_at).last.subject).to eq "Import completed: #{@file.id}"
      end

      it "should be searchable right after the import", solr: true, vcr: true do
        Manifestation.search{ keywords "10101" }.total.should > 0
        Manifestation.search{ keywords "10101", fields: [:item_identifier] }.total.should > 0
        Manifestation.search{ keywords "item_identifier_sm:10101" }.total.should > 0
      end

      it "should import multiple ISBNs", vcr: true do
        file = ResourceImportFile.new(
          user: users(:admin),
          default_shelf_id: 3,
          edit_mode: 'create'
        )
        file.resource_import.attach(io: StringIO.new("original_title\tisbn\noriginal_title_multiple_isbns\t978-4840239219//978-4043898039\n"), filename: 'attachment.txt')
        file.save
        result = file.import_start
        expect(result[:manifestation_created]).to eq 1
        resource_import_result = file.resource_import_results.last
        expect(resource_import_result.manifestation).not_to be_blank
        manifestation = resource_import_result.manifestation
        expect(manifestation.isbn_records.pluck(:body)).to include("9784840239219")
        expect(manifestation.isbn_records.pluck(:body)).to include("9784043898039")
      end
    end

    describe "ISBN import" do
      context "with record not found" do
        it "should record an error message", vcr: true do
          file = ResourceImportFile.new(
            user: users(:admin),
            default_shelf_id: 3,
            edit_mode: 'create'
          )
          file.resource_import.attach(io: StringIO.new("isbn\n9780007264551"), filename: 'attachment.txt')
          file.save
          result = file.import_start
          expect(result[:manifestation_failed]).to eq 1
          resource_import_result = file.resource_import_results.last
          expect(resource_import_result.error_message).not_to be_empty
        end
      end

      context "with ISBN invalid" do
        it "should record an error message", vcr: true do
          file = ResourceImportFile.new(
            user: users(:admin),
            default_shelf_id: 3,
            edit_mode: 'create'
          )
          file.resource_import.attach(io: StringIO.new("isbn\n978000726455x"), filename: 'attachment.txt')
          file.save
          result = file.import_start
          expect(result[:manifestation_failed]).to eq 1
          resource_import_result = file.resource_import_results.last
          expect(resource_import_result.error_message).not_to be_empty
        end
      end
    end

    describe "NDLBibID" do
      it "should import NDLBibID", vcr: true do
        file = ResourceImportFile.new(
          user: users(:admin),
          default_shelf_id: 3,
          edit_mode: 'create'
        )
        file.resource_import.attach(io: StringIO.new("ndl_bib_id\n000000471440\n"), filename: 'attachment.txt')
        file.save!
        result = file.import_start
        expect(result[:manifestation_created]).to eq 1
        resource_import_result = file.resource_import_results.last
        manifestation = resource_import_result.manifestation
        expect(manifestation.manifestation_identifier).to eq "http://iss.ndl.go.jp/books/R100000002-I000000471440-00"
      end
    end

    describe "when it is written in shift_jis" do
      before(:each) do
        @file = ResourceImportFile.new(
          user: users(:admin),
          default_shelf_id: 3,
          edit_mode: 'create'
        )
        @file.resource_import.attach(io: File.new("#{Rails.root}/../../examples/resource_import_file_sample2.tsv"), filename: 'attachment.txt')
        @file.save
        @old_manifestations_count = Manifestation.count
        @old_items_count = Item.count
        @old_agents_count = Agent.count
        @old_import_results_count = ResourceImportResult.count
      end

      it "should be imported", vcr: true do
        expect(@file.import_start).to eq({
          manifestation_created: 9, manifestation_found: 10, manifestation_updated: 0, manifestation_failed: 1, manifestation_skipped: 2,
          item_created: 16, item_found: 3, item_updated: 0, item_failed: 1, item_skipped: 2
        })
        manifestation = Item.find_by(item_identifier: '11111').manifestation
        expect(manifestation.publishers.first.full_name).to eq 'test4'
        expect(manifestation.publishers.first.full_name_transcription).to eq 'てすと4'
        expect(manifestation.publishers.second.full_name_transcription).to eq 'てすと5'
        #Manifestation.count.should eq old_manifestations_count + 10
        #expect(Item.count).to eq @old_items_count + 12
        #Agent.count.should eq old_agents_count + 9
        #ResourceImportResult.count.should eq old_import_results_count + 21
        expect(Item.find_by(item_identifier: '10101').manifestation.creators.count).to eq 2
        expect(Item.find_by(item_identifier: '10101').manifestation.date_of_publication).to eq Time.zone.parse('2001-01-01')
        expect(Item.find_by(item_identifier: '10102').manifestation.date_of_publication).to eq Time.zone.parse('2001-01-01')
        expect(Item.find_by(item_identifier: '10104').manifestation.date_of_publication).to eq Time.zone.parse('2001-01-01')
        expect(Manifestation.find_by(manifestation_identifier: '103').original_title).to eq 'ダブル"クォート"を含む資料'

        # @file.resource_import_fingerprint.should be_truthy
        expect(@file.executed_at).to be_truthy
      end
    end

    describe "when it has only isbn" do
      before(:each) do
        @file = ResourceImportFile.new(
          user: users(:admin),
          default_shelf_id: 3,
          edit_mode: 'create'
        )
        @file.resource_import.attach(io: File.new("#{Rails.root}/../../examples/isbn_sample.txt"), filename: 'attachment.txt')
        @file.save
      end

      it "should be imported", vcr: true do
        old_manifestations_count = Manifestation.count
        old_agents_count = Agent.count
        @file.import_start
        expect(Manifestation.count).to eq old_manifestations_count + 1
        expect(Agent.count).to eq old_agents_count + 4
        expect(Manifestation.order(:id).last.publication_place).to eq '東京'
      end
    end

    describe "when it contains item related fields" do
      it "should create an item as well" do
        import_file = <<-EOF
original_title	call_number	item_note
resource_import_file_test1	007.6	note for the item.
        EOF
        file = ResourceImportFile.new(
          user: users(:admin),
          default_shelf_id: 3,
          edit_mode: 'create'
        )
        file.resource_import.attach(io: StringIO.new(import_file), filename: 'attachment.txt')
        file.save
        old_manifestations_count = Manifestation.count
        old_items_count = Item.count
        result = file.import_start
        expect(Manifestation.count).to eq old_manifestations_count + 1
        expect(Item.count).to eq old_items_count + 1
        expect(file.resource_import_results.last.item).to be_valid
        expect(file.resource_import_results.last.item.call_number).to eq "007.6"
        expect(file.resource_import_results.last.item.note).to eq "note for the item."
      end
    end

    describe "when it contains edition fields" do
      it "should be imported" do
        import_file = <<-EOF
original_title	edition	edition_string
resource_import_file_test_edition	2	Revised Ed.
        EOF
        file = ResourceImportFile.new(
          user: users(:admin),
          default_shelf_id: 3,
          edit_mode: 'create'
        )
        file.resource_import.attach(io: StringIO.new(import_file), filename: 'attachment.txt')
        file.save
        old_manifestations_count = Manifestation.count
        result = file.import_start
        expect(Manifestation.count).to eq old_manifestations_count + 1
        manifestation = Manifestation.all.find{|m| m.original_title == "resource_import_file_test_edition" }
        expect(manifestation.edition).to eq 2
        expect(manifestation.edition_string).to eq "Revised Ed."
      end
    end

    describe "when it contains transcription fields" do
      it "should be imported" do
        import_file = <<-EOF
original_title	title_transcription
resource_import_file_test_transcription	transcription
        EOF
        file = ResourceImportFile.new(
          user: users(:admin),
          default_shelf_id: 3,
          edit_mode: 'create'
        )
        file.resource_import.attach(io: StringIO.new(import_file), filename: 'attachment.txt')
        file.save
        old_manifestations_count = Manifestation.count
        result = file.import_start
        expect(Manifestation.count).to eq old_manifestations_count + 1
        manifestation = Manifestation.all.find{|m| m.original_title == "resource_import_file_test_transcription" }
        expect(manifestation.title_transcription).to eq "transcription"
      end
    end

    describe "when it contains escaped fields" do
      it "should be imported as escaped" do
        import_file = <<-EOF
original_title	description	note	call_number	item_note
resource_import_file_test_description	test\\ntest	test\\ntest	test_description	test\\ntest
        EOF
        file = ResourceImportFile.new(
          user: users(:admin),
          default_shelf_id: 3,
          edit_mode: 'create'
        )
        file.resource_import.attach(io: StringIO.new(import_file), filename: 'attachment.txt')
        file.save
        old_manifestations_count = Manifestation.count
        result = file.import_start
        expect(Manifestation.count).to eq old_manifestations_count + 1
        manifestation = Manifestation.all.find{|m| m.original_title == "resource_import_file_test_description" }
        expect(manifestation.description).to eq "test\\ntest"
        expect(manifestation.note).to eq "test\\ntest"
        expect(manifestation.items.first.note).to eq "test\\ntest"
      end
    end

    describe "when it contains custom properties" do
      xit "should be imported" do
      end
    end
  end

  describe "when its mode is 'update'" do
    it "should update items", vcr: true do
      file = ResourceImportFile.new(
        user: users(:admin),
        edit_mode: 'update'
      )
      file.resource_import.attach(io: File.new("#{Rails.root}/../../examples/item_update_file.tsv"), filename: 'attachment.txt')
      file.save
      file.import_start
      expect(file.resource_import_results.first).to be_truthy
      #expect(file.resource_import_results.first.body).to match /item_identifier/
      item_00001 = Item.find_by(item_identifier: '00001')
      expect(item_00001.manifestation.creators.order('agents.id').pluck(:full_name)).to eq ['たなべ', 'こうすけ']
      expect(item_00001.binding_item_identifier).to eq '900001'
      expect(item_00001.binding_call_number).to eq '336|A'
      expect(item_00001.binded_at).to eq Time.zone.parse('2014-08-16')
      expect(item_00001.manifestation.subjects.order(:id).map{|subject| {subject.subject_heading_type.name => subject.term}}).to eq [{"ndlsh" => "test1"}, {"ndlsh" => "test2"}]
      expect(item_00001.manifestation.isbn_records.pluck(:body)).to eq ["4798002062"]
      expect(Item.find_by(item_identifier: '00002').manifestation.publishers.pluck(:full_name)).to eq ['test2']

      item_00003 = Item.find_by(item_identifier: '00003')
      expect(item_00003.acquired_at).to eq Time.zone.parse('2012-01-01')
      expect(item_00003.include_supplements).to be_truthy

      expect(Item.find_by(item_identifier: '00004').include_supplements).to be_falsy
      expect(Item.find_by(item_identifier: '00025').call_number).to eq "547|ヤ"
    end

    # it "should update series_statement", vcr: true do
    #  manifestation = Manifestation.find(10)
    #  file = ResourceImportFile.create resource_import: File.new("#{Rails.root.to_s}/../../examples/update_series_statement.tsv"), edit_mode: 'update'
    #  file.modify
    #  manifestation.reload
    #  manifestation.series_statements.should eq [SeriesStatement.find(2)]
    # end
  end

  describe "when its mode is 'destroy'" do
    it "should remove items", vcr: true do
      old_count = Item.count
      file = ResourceImportFile.new(
        user: users(:admin),
        default_shelf_id: 3,
        edit_mode: 'destroy'
      )
      file.resource_import.attach(io: File.new("#{Rails.root}/../../examples/item_delete_file.tsv"), filename: 'attachment.txt')
      file.save
      file.import
      expect(Item.count).to eq old_count - 8
    end
  end

  it "should import in background", vcr: true do
    file = ResourceImportFile.new(
      user: users(:admin),
      default_shelf_id: 3,
      edit_mode: 'create'
    )
    file.resource_import.attach(io: File.new("#{Rails.root}/../../examples/resource_import_file_sample1.tsv"), filename: 'attachment.txt')
    file.save
    expect(ResourceImportFileJob.perform_later(file)).to be_truthy
  end
end

# == Schema Information
#
# Table name: resource_import_files
#
#  id                          :bigint           not null, primary key
#  user_id                     :bigint
#  note                        :text
#  executed_at                 :datetime
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  edit_mode                   :string
#  resource_import_fingerprint :string
#  error_message               :text
#  user_encoding               :string
#  default_shelf_id            :integer
#
