require 'rails_helper'

describe Realize do
  # pending "add some examples to (or delete) #{__FILE__}"

end

# == Schema Information
#
# Table name: realizes
#
#  id              :bigint(8)        not null, primary key
#  agent_id        :bigint(8)        not null
#  expression_id   :uuid             not null
#  position        :integer          default(1), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  realize_type_id :integer
#
