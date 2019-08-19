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
    Message.order(:created_at).last.subject.should eq "Export completed: #{file.id}"
  end

  it "should respect the role of the user" do
    export_file = ResourceExportFile.new
    export_file.user = users(:admin)
    export_file.save!
    export_file.export!
    file = export_file.resource_export
    lines = file.download.split("\n")
    columns = lines.first.split(/\t/)
    expect(columns).to include "bookstore"
    expect(columns).to include "budget_type"
    expect(columns).to include "item_price"
  end

  it "should export NCID value" do
    manifestation = FactoryBot.create(:manifestation)
    ncid = IdentifierType.find_by(name: "ncid")
    identifier = FactoryBot.create(:identifier, identifier_type: ncid, body: "BA91833159")
    export_file = ResourceExportFile.new
    export_file.user = users(:admin)
    export_file.save!
    export_file.export!
    file = export_file.resource_export
    expect(file).to be_truthy
    lines = file.download.split("\n")
    expect(lines.first.split(/\t/)).to include "ncid"
    expect(lines.last.split(/\t/)).to include "BA91833159"
  end

  it "should export carrier_type" do
    carrier_type = FactoryBot.create(:carrier_type)
    manifestation = FactoryBot.create(:manifestation, carrier_type: carrier_type)
    manifestation.save!
    export_file = ResourceExportFile.new
    export_file.user = users(:admin)
    export_file.save!
    export_file.export!
    file = export_file.resource_export
    expect(file).to be_truthy
    csv = CSV.parse(file.download, {headers: true, col_sep: "\t"})
    csv.each do |row|
      expect(row).to have_key "carrier_type"
      case row["manifestation_id"].to_i
      when 1
        expect(row["carrier_type"]).to eq "volume"
      when manifestation.id
        expect(row["carrier_type"]).to eq carrier_type.name
      end
    end
  end
end

# == Schema Information
#
# Table name: resource_export_files
#
#  id          :bigint           not null, primary key
#  user_id     :bigint
#  executed_at :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
