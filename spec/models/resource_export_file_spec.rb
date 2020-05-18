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
    lines = File.open(file.path).readlines.map(&:chomp)
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
    lines = File.open(file.path).readlines.map(&:chomp)
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
    csv = CSV.open(file.path, {headers: true, col_sep: "\t"})
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

  it "should export custom properties" do
    item = FactoryBot.create(:item)
    3.times do
      item.manifestation.manifestation_custom_values << FactoryBot.build(:manifestation_custom_value)
    end
    3.times do
      item.item_custom_values << FactoryBot.build(:item_custom_value)
    end
    export_file = ResourceExportFile.new
    export_file.user = users(:admin)
    export_file.save!
    export_file.export!
    csv = CSV.parse(export_file.attachment.download, {headers: true, col_sep: "\t"})
    csv.each do |row|
      if row['manifestation_id'] == item.manifestation.id
        item.manifestation_custom_values.each do |value|
          expect(row).to have_key "manifestation:#{value.manifestation_custom_property.name}"
          expect(row["manifestation:#{value.manifestation_custom_property.name}"]).to eq value
        end
        item.item_custom_values.each do |value|
          expect(row).to have_key "item:#{value.item_custom_property.name}"
          expect(row["item:#{value.item_custom_property.name}"]).to eq value
        end
      end
    end
  end
end

# == Schema Information
#
# Table name: resource_export_files
#
#  id                           :bigint           not null, primary key
#  user_id                      :integer
#  resource_export_file_name    :string
#  resource_export_content_type :string
#  resource_export_file_size    :bigint
#  resource_export_updated_at   :datetime
#  executed_at                  :datetime
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#
