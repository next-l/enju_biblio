require 'rails_helper'
  
describe ResourceExportFile do
  fixtures :all
  
  it "should export in background" do
    pending "send notification using Message model #{__FILE__}"
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
    lines = StringIO.new(export_file.resource_export.download).readlines.map(&:chomp)
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
    csv = CSV.parse(file.download, {headers: true, col_sep: "\t"})
    csv.each do |row|
      expect(row).to have_key "carrier_type"
      case row["manifestation_id"]
      when manifestations(:manifestation_00001).id
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
