# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :produce_type do
    name { "mystring" }
    display_name { "MyText" }
    note { "MyText" }
  end
end

# == Schema Information
#
# Table name: produce_types
#
#  id           :integer          not null, primary key
#  name         :string           not null
#  display_name :text
#  note         :text
#  position     :integer          default(1), not null
#  created_at   :datetime
#  updated_at   :datetime
#
