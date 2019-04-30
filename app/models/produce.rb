class Produce < ActiveRecord::Base
  belongs_to :agent
  belongs_to :manifestation, touch: true
  belongs_to :produce_type, optional: true
  delegate :original_title, to: :manifestation, prefix: true

  validates_associated :agent, :manifestation
  validates_presence_of :agent, :manifestation
  validates_uniqueness_of :manifestation_id, scope: :agent_id
  after_save :reindex
  after_destroy :reindex

  acts_as_list scope: :manifestation
  translates :full_name

  def reindex
    agent.try(:index)
    manifestation.try(:index)
  end
end

# == Schema Information
#
# Table name: produces
#
#  id                     :bigint           not null, primary key
#  agent_id               :bigint           not null
#  manifestation_id       :bigint           not null
#  position               :integer          default(1), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  produce_type_id        :integer
#  full_name_translations :jsonb
#
