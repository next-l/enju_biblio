class Publisher < ApplicationRecord
  belongs_to :produce
  belongs_to :agent
  validates :agent, uniquenss: {scope: :produce}
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
