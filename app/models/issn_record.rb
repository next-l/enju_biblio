class IssnRecord < ActiveRecord::Base
  belongs_to :manifestation
  validates :body, presence: true, uniqueness: {scope: :issn_type}
end

# == Schema Information
#
# Table name: issn_records
#
#  id               :integer          not null, primary key
#  body             :string           not null
#  issn_type        :string
#  source           :string
#  manifestation_id :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
