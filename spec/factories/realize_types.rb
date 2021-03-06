# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :realize_type do
    sequence(:name){|n| "mystring_#{n}" }
    display_name { "MyText" }
    note { "MyText" }
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
