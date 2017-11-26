class Create < ActiveRecord::Base
  belongs_to :agent
  belongs_to :work, class_name: 'Manifestation', foreign_key: 'work_id', touch: true
  belongs_to :create_type

  validates_associated :agent, :work
  validates :work_id, presence: true, uniqueness: {scope: :agent_id}
  after_save :reindex
  after_destroy :reindex

  acts_as_list scope: :work

  def reindex
    agent.try(:index)
    work.try(:index)
  end
end

# == Schema Information
#
# Table name: creates
#
#  id             :integer          not null, primary key
#  agent_id       :uuid             not null
#  work_id        :uuid             not null
#  position       :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  create_type_id :integer
#
