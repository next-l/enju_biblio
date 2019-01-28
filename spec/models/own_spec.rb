require 'rails_helper'

describe Own do
  # pending "add some examples to (or delete) #{__FILE__}"

end

# == Schema Information
#
# Table name: owns
#
#  id         :bigint(8)        not null, primary key
#  agent_id   :uuid             not null
#  item_id    :uuid             not null
#  position   :integer          default(1), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
