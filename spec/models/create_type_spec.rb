require 'rails_helper'

describe CreateType do
  it 'should create create_type' do
    FactoryBot.create(:create_type)
  end
end

# == Schema Information
#
# Table name: create_types
#
#  id           :bigint(8)        not null, primary key
#  name         :string
#  display_name :jsonb            not null
#  note         :text
#  position     :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
