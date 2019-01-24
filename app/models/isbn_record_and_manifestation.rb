class IsbnRecordAndManifestation < ApplicationRecord
  belongs_to :isbn_record
  belongs_to :manifestation
  validates :isbn_record_id, uniqueness: {scope: :manifestation_id}
  acts_as_list
end

# == Schema Information
#
# Table name: isbn_record_and_manifestations
#
#  id               :bigint(8)        not null, primary key
#  isbn_record_id   :bigint(8)        not null
#  manifestation_id :uuid             not null
#  position         :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
