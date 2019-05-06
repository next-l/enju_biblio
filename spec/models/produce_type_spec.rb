require 'rails_helper'

describe ProduceType do
  it 'should create produce_type' do
    FactoryBot.create(:produce_type)
  end
end

# == Schema Information
#
# Table name: produce_types
#
#  id                        :bigint           not null, primary key
#  name                      :string           not null
#  display_name_translations :jsonb            not null
#  note                      :text
#  position                  :integer          default(1), not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
