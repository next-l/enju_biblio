require 'rails_helper'

describe Frequency do
  fixtures :frequencies

  it "should should have display_name" do
    frequencies(:frequency_00001).display_name.should_not be_nil
  end
end

# == Schema Information
#
# Table name: frequencies
#
#  id                        :bigint           not null, primary key
#  name                      :string           not null
#  display_name_translations :jsonb            not null
#  note                      :text
#  position                  :integer          default(1), not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
