FactoryBot.define do
  factory :issn_record do
    sequence(:body){|n| "1122334#{n}"}
  end
end

# == Schema Information
#
# Table name: issn_records
#
#  id         :bigint(8)        not null, primary key
#  body       :string           not null
#  issn_type  :string
#  source     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
