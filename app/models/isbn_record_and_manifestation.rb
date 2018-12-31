class IsbnRecordAndManifestation < ApplicationRecord
  belongs_to :isbn_record
  belongs_to :manifestation
  acts_as_list
end

# == Schema Information
#
# Table name: isbn_record_and_manifestations
#
#  id               :bigint(8)        not null, primary key
#  isbn_record_id   :bigint(8)        not null
#  manifestation_id :bigint(8)        not null
#  position         :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
