require 'rails_helper'

RSpec.describe Publisher, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: publishers
#
#  id         :bigint(8)        not null, primary key
#  produce_id :bigint(8)        not null
#  agent_id   :uuid             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
