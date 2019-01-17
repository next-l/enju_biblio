# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :create_type do
    name { "mystring" }
    display_name { "MyText" }
    note { "MyText" }
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
