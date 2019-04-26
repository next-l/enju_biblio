class PeriodicalAndManifestation < ApplicationRecord
  belongs_to :periodical
  belongs_to :manifestation
end

# == Schema Information
#
# Table name: periodical_and_manifestations
#
#  id                :bigint(8)        not null, primary key
#  periodical_id     :bigint(8)        not null
#  manifestation_id  :bigint(8)        not null
#  periodical_master :boolean          default(FALSE), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
