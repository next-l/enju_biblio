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
        manifestation_101.series_statements.first.title_subseries.should eq '副シリーズ 1'
        manifestation_101.series_statements.first.title_subseries_transcription.should eq 'ふくしりーず いち'

        item_10101 = Item.where(item_identifier: '10101').first
        item_10101.manifestation.creators.size.should eq 2
        item_10101.manifestation.creates.order(:id).first.create_type.name.should eq 'author'
        item_10101.manifestation.creates.order(:id).second.agent.full_name.should eq 'test1'
        item_10101.manifestation.creates.order(:id).second.create_type.name.should eq 'illustrator'
        item_10101.manifestation.date_of_publication.should eq Time.zone.parse('2001-01-01')
        item_10101.budget_type.name.should eq 'Public fund'
        item_10101.bookstore.name.should eq 'Example store'
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

        item_10102 = Item.where(item_identifier: '10102').first
        item_10102.manifestation.date_of_publication.should eq Time.zone.parse('2001-01-01')
        item_10102.manifestation.language.name.should eq 'Japanese'

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

      it "should send message when import is completed" do
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
      Item.where(item_identifier: '00001').first.manifestation.creators.order('agents.id').collect(&:full_name).should eq ['たなべ', 'こうすけ']
      Item.where(item_identifier: '00002').first.manifestation.publishers.collect(&:full_name).should eq ['test2']
      Item.where(item_identifier: '00003').first.manifestation.original_title.should eq 'テスト3'
      Item.where(item_identifier: '00003').first.acquired_at.should eq Time.zone.parse('2012-01-01')
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

