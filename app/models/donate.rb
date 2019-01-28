class Donate < ActiveRecord::Base
  belongs_to :agent
  belongs_to :item
  validates_associated :agent, :item
  validates_presence_of :agent, :item
end

# == Schema Information
#
# Table name: donates
#
#  id         :bigint(8)        not null, primary key
#  agent_id   :uuid             not null
#  item_id    :uuid             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
