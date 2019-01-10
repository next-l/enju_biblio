FactoryBot.define do
  factory :isbn_record do
    sequence(:body){|n| "112233445566#{n}"}
  end
end

# == Schema Information
#
# Table name: isbn_records
#
#  id         :bigint(8)        not null, primary key
#  body       :string           not null
#  isbn_type  :string
#  source     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
