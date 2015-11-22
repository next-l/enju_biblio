# -*- encoding: utf-8 -*-
require 'spec_helper'
  
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
#  id                           :integer          not null, primary key
#  user_id                      :integer
#  resource_export_file_name    :string(255)
#  resource_export_content_type :string(255)
#  resource_export_file_size    :integer
#  resource_export_updated_at   :datetime
#  executed_at                  :datetime
#  created_at                   :datetime
#  updated_at                   :datetime
#
