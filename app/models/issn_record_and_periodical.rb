class IssnRecordAndPeriodical < ApplicationRecord
  belongs_to :issn_record
  belongs_to :periodical
end

# == Schema Information
#
# Table name: issn_record_and_periodicals
#
#  id             :integer          not null, primary key
#  issn_record_id :integer          not null
#  periodical_id  :uuid             not null
#  position       :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
