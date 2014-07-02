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
#  created_at                   :datetime
#  updated_at                   :datetime
#  edit_mode                    :string(255)
#  resource_import_fingerprint  :string(255)
#  error_message                :text
#  user_encoding                :string(255)
#
