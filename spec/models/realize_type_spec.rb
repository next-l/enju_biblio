require 'rails_helper'

describe RealizeType do
  it 'should create realize_type' do
    FactoryBot.create(:realize_type)
  end
end

# == Schema Information
#
# Table name: realize_types
#
#  id                        :bigint           not null, primary key
#  name                      :string
#  note                      :text
#  position                  :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  display_name_translations :jsonb            not null
#
