class Creator < ApplicationRecord
  belongs_to :create
  belongs_to :agent
  validates :agent, uniquenss: {scope: :create}
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
