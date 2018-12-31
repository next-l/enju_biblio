require 'rails_helper'

describe CarrierType do
  fixtures :carrier_types

  it "should respond to mods_type" do
    carrier_types(:carrier_type_00001).mods_type.should eq 'text'
    carrier_types(:carrier_type_00002).mods_type.should eq 'software, multimedia'
  end
end

# == Schema Information
#
# Table name: carrier_types
#
#  id                      :integer          not null, primary key
#  name                    :string           not null
#  display_name            :text
#  note                    :text
#  position                :integer          default(1), not null
#  created_at              :datetime
#  updated_at              :datetime
#  attachment_file_name    :string
#  attachment_content_type :string
#  attachment_file_size    :bigint(8)
#  attachment_updated_at   :datetime
#
