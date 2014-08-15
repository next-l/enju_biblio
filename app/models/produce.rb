class Produce < ActiveRecord::Base
  attr_accessible :agent_id, :manifestation_id, :produce_type_id, :position
  belongs_to :agent
  belongs_to :manifestation
  belongs_to :produce_type
  delegate :original_title, :to => :manifestation, :prefix => true

  validates_associated :agent, :manifestation
  validates_presence_of :agent, :manifestation
  validates_uniqueness_of :manifestation_id, scope: :agent_id
  after_save :reindex
  after_destroy :reindex

  acts_as_list scope: :manifestation

  def reindex
    agent.try(:index)
    manifestation.try(:index)
  end
end

# == Schema Information
#
# Table name: produces
#
#  id               :integer          not null, primary key
#  agent_id         :integer          not null
#  manifestation_id :integer          not null
#  position         :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  produce_type_id  :integer
#

