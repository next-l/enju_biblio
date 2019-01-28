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
    Message.order(:created_at).last.subject.should eq 'エクスポートが完了しました'
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

  it "should export total_checkouts" do
    item1 = FactoryBot.create(:item)
    item2 = FactoryBot.create(:item)
    checkout = FactoryBot.create(:checkout, item: item2)
    export_file = ResourceExportFile.new
    export_file.user = users(:admin)
    export_file.save!
    export_file.export!
    file = export_file.resource_export
    expect(file).to be_truthy
    csv = CSV.open(file.path, {headers: true, col_sep: "\t"})
    csv.each do |row|
      expect(row).to have_key "total_checkouts"
      case row["item_id"].to_i
      when item1.id
        expect(row["total_checkouts"].to_i).to eq 0
      when item2.id
        expect(row["total_checkouts"].to_i).to eq 1
      end
    end
  end
end

# == Schema Information
#
# Table name: resource_export_files
#
#  id                           :bigint(8)        not null, primary key
#  user_id                      :bigint(8)
#  resource_export_file_name    :string
#  resource_export_content_type :string
#  resource_export_file_size    :bigint(8)
#  resource_export_updated_at   :datetime
#  executed_at                  :datetime
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#
