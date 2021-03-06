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
    file = export_file.attachment
    lines = file.download.split("\n")
    columns = lines.first.split(/\t/)
    expect(columns).to include "bookstore"
    expect(columns).to include "budget_type"
    expect(columns).to include "item_price"
  end

  it "should export custom identifier's value" do
    manifestation = FactoryBot.create(:manifestation)
    custom = IdentifierType.find_by(name: "custom")
    identifier = FactoryBot.create(:identifier, identifier_type: custom, body: "a11223344")
    export_file = ResourceExportFile.new
    export_file.user = users(:admin)
    export_file.save!
    export_file.export!
    file = export_file.attachment
    expect(file).to be_truthy
    lines = file.download.split("\n")
    expect(lines.first.split(/\t/)).to include "identifier:custom"
    expect(lines.last.split(/\t/)).to include "a11223344"
  end

  it "should export carrier_type" do
    carrier_type = FactoryBot.create(:carrier_type)
    manifestation = FactoryBot.create(:manifestation, carrier_type: carrier_type)
    manifestation.save!
    export_file = ResourceExportFile.new
    export_file.user = users(:admin)
    export_file.save!
    export_file.export!
    file = export_file.attachment
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

  it "should export create_type, realize_type and produce_type" do
    export_file = ResourceExportFile.new
    export_file.user = users(:admin)
    export_file.save!
    export_file.export!
    CSV.parse(export_file.attachment.download, {headers: true, col_sep: "\t"}).each do |row|
      manifestation = Manifestation.find(row['manifestation_id'])
      manifestation.creates.each do |create|
        if create.create_type
          expect(row['creator']).to match "#{create.agent.full_name}||#{create.create_type.name}"
        end
      end

      manifestation.realizes.each do |realize|
        if realize.realize_type
          expect(row['contributor']).to match "#{realize.agent.full_name}||#{realize.realize_type.name}"
        end
      end

      manifestation.produces.each do |produce|
        if produce.produce_type
          expect(row['publisher']).to match "#{produce.agent.full_name}||#{produce.produce_type.name}"
        end
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
#  id          :bigint           not null, primary key
#  user_id     :bigint
#  executed_at :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
