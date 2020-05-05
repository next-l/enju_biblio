require 'rails_helper'

describe CarrierType do
  fixtures :carrier_types

  it "should respond to mods_type" do
    expect(carrier_types(:carrier_type_00001).mods_type).to eq 'text'
    expect(carrier_types(:carrier_type_00002).mods_type).to eq 'software, multimedia'
  end
end

# == Schema Information
#
# Table name: carrier_types
#
#  id                        :bigint           not null, primary key
#  name                      :string           not null
#  note                      :text
#  position                  :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  display_name_translations :jsonb            not null
#
