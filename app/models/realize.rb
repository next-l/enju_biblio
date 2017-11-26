class Realize < ActiveRecord::Base
  belongs_to :agent
  belongs_to :expression, class_name: 'Manifestation', foreign_key: 'expression_id', touch: true
  belongs_to :realize_type

  validates_associated :agent, :expression
  validates_presence_of :agent, :expression
  validates_uniqueness_of :expression_id, scope: :agent_id
  after_save :reindex
  after_destroy :reindex

  acts_as_list scope: :expression

  def reindex
    agent.try(:index)
    expression.try(:index)
  end
end

# == Schema Information
#
# Table name: realizes
#
#  id              :integer          not null, primary key
#  agent_id        :uuid             not null
#  expression_id   :uuid             not null
#  position        :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  realize_type_id :integer
#
