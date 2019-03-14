require 'rails_helper'

RSpec.describe Contributor, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: contributors
#
#  id         :bigint(8)        not null, primary key
#  realize_id :bigint(8)        not null
#  agent_id   :uuid             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
