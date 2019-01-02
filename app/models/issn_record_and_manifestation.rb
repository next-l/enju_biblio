class IssnRecordAndManifestation < ApplicationRecord
  belongs_to :issn_record
  belongs_to :manifestation
  acts_as_list
  validates :issn_record_id, uniqueness: {scope: :manifestation_id}
end

# == Schema Information
#
# Table name: issn_record_and_manifestations
#
#  id               :bigint(8)        not null, primary key
#  issn_record_id   :bigint(8)        not null
#  manifestation_id :bigint(8)        not null
#  position         :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
