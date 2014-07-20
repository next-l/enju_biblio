# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :realize_type do
    name "mystring"
    display_name "MyText"
    note "MyText"
  end
end

# == Schema Information
#
# Table name: realize_types
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  display_name :text
#  note         :text
#  position     :integer
#  created_at   :datetime
#  updated_at   :datetime
#
