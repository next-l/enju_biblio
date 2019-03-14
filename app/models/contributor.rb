class Contributor < ApplicationRecord
  belongs_to :realize
  belongs_to :agent
  validates :agent, uniquenss: {scope: :realize}
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
