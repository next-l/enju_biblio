class DoiRecord < ApplicationRecord
  belongs_to :manifestation
  validates :body, presence: true
end

# == Schema Information
#
# Table name: doi_records
#
#  id               :bigint(8)        not null, primary key
#  body             :string           not null
#  display_body     :string           not null
#  source           :string
#  response         :jsonb            not null
#  manifestation_id :uuid             not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
