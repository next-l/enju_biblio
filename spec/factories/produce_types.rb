# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :produce_type do
    name "MyString"
    display_name "MyText"
    note "MyText"
  end
end

# == Schema Information
#
# Table name: produce_types
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  display_name :text
#  note         :text
#  position     :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
