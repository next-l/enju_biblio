class IssnRecordAndManifestation < ApplicationRecord
  belongs_to :issn_record
  belongs_to :manifestation
  acts_as_list
end

# == Schema Information
#
# Table name: issn_record_and_manifestations
#
#  id               :integer          not null, primary key
#  issn_record_id   :integer          not null
#  manifestation_id :uuid             not null
#  position         :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
