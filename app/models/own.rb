class Own < ActiveRecord::Base
  belongs_to :agent
  belongs_to :item

  validates_associated :agent, :item
  validates_presence_of :agent, :item
  validates_uniqueness_of :item_id, scope: :agent_id
  after_save :reindex
  after_destroy :reindex

  acts_as_list scope: :item

  attr_accessor :item_identifier

  def reindex
    agent.try(:index)
    item.try(:index)
  end
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
