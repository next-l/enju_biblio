require 'rails_helper'

RSpec.describe Creator, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: creators
#
#  id         :bigint(8)        not null, primary key
#  create_id  :bigint(8)        not null
#  agent_id   :uuid             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
