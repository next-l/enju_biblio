# -*- encoding: utf-8 -*-
require 'spec_helper'
  
describe ResourceExportFile do
  fixtures :all
  
  it "should export in background" do
    file = ResourceExportFile.new
    file.user = users(:admin)
    file.save
    ResourceExportFileQueue.perform(file.id).should be_true
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
