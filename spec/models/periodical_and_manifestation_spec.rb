require 'rails_helper'

RSpec.describe PeriodicalAndManifestation, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
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
