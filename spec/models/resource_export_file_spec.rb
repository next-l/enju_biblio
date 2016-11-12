# -*- encoding: utf-8 -*-
require 'rails_helper'
  
describe ResourceExportFile do
  fixtures :all
  
  it "should export in background" do
    message_count = Message.count
    file = ResourceExportFile.new
    file.user = users(:admin)
    file.save
    ResourceExportFileJob.perform_later(file).should be_truthy
    Message.count.should eq message_count + 1
    Message.order(:id).last.subject.should eq 'エクスポートが完了しました'
  end

  it "should respect the role of the user" do
    export_file = ResourceExportFile.new
    export_file.user = users(:admin)
    export_file.save!
    export_file.export!
    file = export_file.resource_export
    lines = File.open(file.path).readlines.map(&:chomp)
    columns = lines.first.split(/\t/)
    expect(columns).to include "bookstore"
    expect(columns).to include "budget_type"
    expect(columns).to include "item_price"
  end

  context "NCID export" do
    it "should export NCID value" do
      manifestation = FactoryGirl.create(:manifestation)
      ncid = IdentifierType.where(name: "ncid").first
      identifier = FactoryGirl.create(:identifier, identifier_type: ncid, body: "BA91833159")
      manifestation.identifiers << identifier
      manifestation.save!
      export_file = ResourceExportFile.new
      export_file.user = users(:admin)
      export_file.save!
      export_file.export!
      file = export_file.resource_export
      expect(file).to be_truthy
      lines = File.open(file.path).readlines.map(&:chomp)
      expect(lines.first.split(/\t/)).to include "ncid"
      expect(lines.last.split(/\t/)).to include "BA91833159"
    end
  end
end

# == Schema Information
#
# Table name: resource_export_files
#
#  id                       :integer          not null, primary key
#  user_id                  :integer
#  executed_at              :datetime
#  created_at               :datetime
#  updated_at               :datetime
#  resource_export_id       :string
#  resource_export_size     :integer
#  resource_export_filename :string
#  attachment_data          :jsonb
#
