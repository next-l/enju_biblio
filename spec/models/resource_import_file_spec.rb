# -*- encoding: utf-8 -*-
require 'spec_helper'
  
describe ResourceImportFile do
  fixtures :all
  
  describe "when its mode is 'create'" do
    describe "when it is written in utf-8" do
      before(:each) do
        @file = ResourceImportFile.create resource_import: File.new("#{Rails.root.to_s}/../../examples/resource_import_file_sample1.tsv"), default_shelf_id: 3
        @file.user = users(:admin)
      end

      it "should be imported", vcr: true do
        old_manifestations_count = Manifestation.count
        old_items_count = Item.count
        old_agents_count = Agent.count
        old_import_results_count = ResourceImportResult.count
        @file.import_start.should eq({:manifestation_imported => 9, :item_imported => 6, :manifestation_found => 3, :item_found => 3, :failed => 7})
        manifestation = Item.where(item_identifier: '11111').first.manifestation
        manifestation.publishers.first.full_name.should eq 'test4'
        manifestation.publishers.first.full_name_transcription.should eq 'てすと4'
        manifestation.publishers.second.full_name_transcription.should eq 'てすと5'
        manifestation.produces.first.produce_type.name.should eq 'publisher'
        manifestation.creates.first.create_type.name.should eq 'author'
        Manifestation.count.should eq old_manifestations_count + 9
        Item.count.should eq old_items_count + 6
        Agent.count.should eq old_agents_count + 9
        ResourceImportResult.count.should eq old_import_results_count + 17

        manifestation_101 = Manifestation.where(:manifestation_identifier => '101').first
        manifestation_101.series_statements.count.should eq 1
        manifestation_101.series_statements.first.original_title.should eq '主シリーズ'
        manifestation_101.series_statements.first.title_transcription.should eq 'しゅしりーず'
        manifestation_101.series_statements.first.title_subseries.should eq '副シリーズ'
        manifestation_101.series_statements.first.title_subseries_transcription.should eq 'ふくしりーず'

        item_10101 = Item.where(item_identifier: '10101').first
        item_10101.manifestation.creators.size.should eq 2
        item_10101.manifestation.creates.order(:id).first.create_type.name.should eq 'author'
        item_10101.manifestation.creates.order(:id).second.agent.full_name.should eq 'test1'
        item_10101.manifestation.creates.order(:id).second.create_type.name.should eq 'illustrator'
        item_10101.manifestation.date_of_publication.should eq Time.zone.parse('2001-01-01')
        item_10101.budget_type.name.should eq 'Public fund'
        item_10101.bookstore.name.should eq 'Example store'
        item_10101.manifestation.classifications.count.should eq 1
        item_10101.manifestation.classifications.first.classification_type.name.should eq 'ndc'
        item_10101.manifestation.classifications.first.category.should eq '007'
        item_10101.manifestation.language.name.should eq 'Japanese'
        item_10101.manifestation.statement_of_responsibility.should eq '著者A; 著者B'
        item_10101.binding_item_identifier.should eq '9001'
        item_10101.binding_call_number.should eq '330|A'
        item_10101.binded_at.should eq Time.zone.parse('2014-08-16')
        item_10101.manifestation.publication_place.should eq '東京'
        item_10101.include_supplements.should eq true
        item_10101.note.should eq 'カバーなし'
        item_10101.url.should eq 'http://example.jp/item/1'
        item_10101.manifestation.carrier_type.name.should eq 'volume'
        item_10101.manifestation.manifestation_content_type.name.should eq 'text'
        item_10101.manifestation.frequency.name.should eq 'monthly'
        item_10101.manifestation.extent_of_text.should eq 'xv, 213 pages'

        item_10102 = Item.where(item_identifier: '10102').first
        item_10102.manifestation.date_of_publication.should eq Time.zone.parse('2001-01-01')
        item_10102.manifestation.language.name.should eq 'Japanese'
        item_10102.manifestation.height.should eq 257
        item_10102.manifestation.width.should eq 182
        item_10102.manifestation.depth.should eq 12
        item_10102.manifestation.start_page.should eq 1
        item_10102.manifestation.end_page.should eq 200
        item_10102.manifestation.series_statements.first.creator_string.should eq 'シリーズの著者'
        item_10102.manifestation.series_statements.first.volume_number_string.should eq 'シリーズ1号'

        Manifestation.where(:manifestation_identifier => '103').first.original_title.should eq 'ダブル"クォート"を含む資料'
        item = Item.where(item_identifier: '11111').first
        item.shelf.name.should eq Shelf.find(3).name
        item.manifestation.price.should eq 1000
        item.price.should eq 0
        item.manifestation.publishers.size.should eq 2

        item_10103 = Item.where(item_identifier: '10103').first
        item_10103.budget_type.should be_nil
        item_10103.bookstore.name.should eq 'Example store'

        item_10104 = Item.where(item_identifier: '10104').first
        item_10104.manifestation.date_of_publication.should eq Time.zone.parse('2001-01-01')
        item_10104.budget_type.name.should eq 'Public fund'
        item_10104.bookstore.should be_nil
        item_10104.call_number.should eq '007|A'
        item_10104.manifestation.carrier_type.name.should eq 'online_resource'
        item_10104.manifestation.manifestation_content_type.name.should eq 'still_image'
        item_10104.manifestation.frequency.name.should eq 'unknown'
        item_10104.manifestation.volume_number_string.should eq '第3巻'
        item_10104.manifestation.volume_number.should eq 3
        item_10104.manifestation.issue_number_string.should eq '第10号'
        item_10104.manifestation.issue_number.should eq 10
        item_10104.manifestation.edition_string.should eq '初版'
        item_10104.manifestation.edition.should eq 1
        item_10104.manifestation.serial_number.should eq 120
        item_10104.manifestation.identifier_contents(:doi).should eq ['example/2014.08.18']
        item_10104.manifestation.height.should be_nil
        item_10104.manifestation.width.should be_nil
        item_10104.manifestation.depth.should be_nil
        item_10104.manifestation.subjects.map{|s| {s.subject_heading_type.name => s.term}}.should eq [{"ndlsh" => "コンピュータ"}, {"ndlsh" => "図書館"}]
        item_10104.manifestation.classifications.map{|c| {c.classification_type.name => c.category}}.should eq [{"ndc" => "007"}, {"ddc" => "003"}, {"ddc" => "004"}]

        manifestation_104 = Manifestation.where(:manifestation_identifier => '104').first
        manifestation_104.identifier_contents(:isbn).should eq ['9784797327038']
        manifestation_104.original_title.should eq 'test10'
        manifestation_104.creators.collect(&:full_name).should eq ['test3']
        manifestation_104.publishers.collect(&:full_name).should eq ['test4']

        @file.resource_import_fingerprint.should be_truthy
        @file.executed_at.should be_truthy

        @file.reload
        @file.error_message.should eq "The follwing column(s) were ignored: invalid"
      end

      it "should send message when import is completed", vcr: true do
        old_message_count = Message.count
        @file.import_start
        Message.count.should eq old_message_count + 1
        Message.order(:id).last.subject.should eq 'インポートが完了しました'
      end
    end

    describe "when it is written in shift_jis" do
      before(:each) do
        @file = ResourceImportFile.create resource_import: File.new("#{Rails.root.to_s}/../../examples/resource_import_file_sample2.tsv")
        @file.user = users(:admin)
      end

      it "should be imported", vcr: true do
        old_manifestations_count = Manifestation.count
        old_items_count = Item.count
        old_agents_count = Agent.count
        old_import_results_count = ResourceImportResult.count
        @file.import_start.should eq({:manifestation_imported => 9, :item_imported => 6, :manifestation_found => 3, :item_found => 3, :failed => 7})
        manifestation = Item.where(item_identifier: '11111').first.manifestation
        manifestation.publishers.first.full_name.should eq 'test4'
        manifestation.publishers.first.full_name_transcription.should eq 'てすと4'
        manifestation.publishers.second.full_name_transcription.should eq 'てすと5'
        Manifestation.count.should eq old_manifestations_count + 9
        Item.count.should eq old_items_count + 6
        Agent.count.should eq old_agents_count + 9
        ResourceImportResult.count.should eq old_import_results_count + 17
        Item.where(item_identifier: '10101').first.manifestation.creators.size.should eq 2
        Item.where(item_identifier: '10101').first.manifestation.date_of_publication.should eq Time.zone.parse('2001-01-01')
        Item.where(item_identifier: '10102').first.manifestation.date_of_publication.should eq Time.zone.parse('2001-01-01')
        Item.where(item_identifier: '10104').first.manifestation.date_of_publication.should eq Time.zone.parse('2001-01-01')
        Manifestation.where(:manifestation_identifier => '103').first.original_title.should eq 'ダブル"クォート"を含む資料'
        item = Item.where(item_identifier: '11111').first
        item.shelf.name.should eq Shelf.where(name: 'web').first.name
        item.manifestation.price.should eq 1000
        item.price.should eq 0
        item.manifestation.publishers.size.should eq 2

        @file.resource_import_fingerprint.should be_truthy
        @file.executed_at.should be_truthy
      end
    end

    describe "when it has only isbn" do
      before(:each) do
        @file = ResourceImportFile.create resource_import: File.new("#{Rails.root.to_s}/../../examples/isbn_sample.txt")
        @file.user = users(:admin)
      end

      it "should be imported", vcr: true do
        old_manifestations_count = Manifestation.count
        old_agents_count = Agent.count
        @file.import_start
        Manifestation.count.should eq old_manifestations_count + 1
        Agent.count.should eq old_agents_count + 4
        Manifestation.order(:id).last.publication_place.should eq '東京'
      end
    end
  end

  describe "when its mode is 'update'" do
    it "should update items", vcr: true do
      @file = ResourceImportFile.create resource_import: File.new("#{Rails.root.to_s}/../../examples/item_update_file.tsv"), edit_mode: 'update'
      @file.modify
      item_00001 = Item.where(item_identifier: '00001').first
      item_00001.manifestation.creators.order('agents.id').collect(&:full_name).should eq ['たなべ', 'こうすけ']
      item_00001.binding_item_identifier.should eq '900001'
      item_00001.binding_call_number.should eq '336|A'
      item_00001.binded_at.should eq Time.zone.parse('2014-08-16')
      item_00001.manifestation.subjects.map{|subject| {subject.subject_heading_type.name => subject.term}}.should eq [{"ndlsh" => "test1"}, {"ndlsh" => "test2"}]
      item_00001.manifestation.identifier_contents(:isbn).should eq ["4798002062", "12345678"]
      Item.where(item_identifier: '00002').first.manifestation.publishers.collect(&:full_name).should eq ['test2']

      item_00003 = Item.where(item_identifier: '00003').first
      item_00003.acquired_at.should eq Time.zone.parse('2012-01-01')
      item_00003.include_supplements.should be_truthy

      Item.where(item_identifier: '00004').first.include_supplements.should be_falsy
    end

    it "should update series_statement", vcr: true do
      manifestation = Manifestation.find(10)
      file = ResourceImportFile.create resource_import: File.new("#{Rails.root.to_s}/../../examples/update_series_statement.tsv"), edit_mode: 'update'
      file.modify
      #manifestation.reload
      #manifestation.series_statements.should eq [SeriesStatement.find(2)]
    end
  end

  describe "when its mode is 'destroy'" do
    it "should remove items", vcr: true do
      old_count = Item.count
      @file = ResourceImportFile.create resource_import: File.new("#{Rails.root.to_s}/../../examples/item_delete_file.tsv"), edit_mode: 'destroy'
      @file.remove
      Item.count.should eq old_count - 2
    end
  end

  it "should import in background", vcr: true do
    file = ResourceImportFile.create resource_import: File.new("#{Rails.root.to_s}/../../examples/resource_import_file_sample1.tsv")
    file.user = users(:admin)
    file.save
    ResourceImportFileQueue.perform(file.id).should be_truthy
  end
end
  
# == Schema Information
#
# Table name: resource_import_files
#
#  id                           :integer          not null, primary key
#  parent_id                    :integer
#  content_type                 :string(255)
#  size                         :integer
#  user_id                      :integer
#  note                         :text
#  executed_at                  :datetime
#  resource_import_file_name    :string(255)
#  resource_import_content_type :string(255)
#  resource_import_file_size    :integer
#  resource_import_updated_at   :datetime
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  edit_mode                    :string(255)
#  resource_import_fingerprint  :string(255)
#  error_message                :text
#  user_encoding                :string(255)
#  default_shelf_id             :integer
#

# == Schema Information
#
# Table name: resource_import_files
#
#  id                           :integer          not null, primary key
#  parent_id                    :integer
#  content_type                 :string(255)
#  size                         :integer
#  user_id                      :integer
#  note                         :text
#  executed_at                  :datetime
#  state                        :string(255)
#  resource_import_file_name    :string(255)
#  resource_import_content_type :string(255)
#  resource_import_file_size    :integer
#  resource_import_updated_at   :datetime
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  edit_mode                    :string(255)
#  resource_import_fingerprint  :string(255)
#  error_message                :text
#  user_encoding                :string(255)
#

