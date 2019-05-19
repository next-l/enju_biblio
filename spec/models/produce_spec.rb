require 'rails_helper'

describe Produce do
  # pending "add some examples to (or delete) #{__FILE__}"

end

# == Schema Information
#
# Table name: produces
#
#  id               :integer          not null, primary key
#  agent_id         :integer          not null
#  manifestation_id :integer          not null
#  position         :integer          default(1), not null
#  created_at       :datetime
#  updated_at       :datetime
#  produce_type_id  :integer
#
