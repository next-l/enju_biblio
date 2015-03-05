# -*- encoding: utf-8 -*-
require 'spec_helper'
  
describe ResourceExportFile do
  fixtures :all
  
  it "should export in background" do
    file = ResourceExportFile.new
    file.user = users(:admin)
    file.save
    ResourceExportFileJob.perform_later(file).should be_truthy
  end

  it "should send message" do
    message_count = Message.count
    file = ResourceExportFile.new
    file.user = users(:admin)
    file.save
    file.export!
    Message.count.should eq message_count + 1
    Message.order(:id).last.subject.should eq 'エクスポートが完了しました'
  end
end

# == Schema Information
#
# Table name: resource_export_files
#
#  id                           :integer          not null, primary key
#  user_id                      :integer
#  executed_at                  :datetime
#  created_at                   :datetime
#  updated_at                   :datetime
#  resource_export_id           :string
#  resource_export_file_name    :string
#  resource_export_size         :integer
#  resource_export_content_type :integer
#
