class Realize < ApplicationRecord
  belongs_to :agent
  belongs_to :expression, class_name: 'Manifestation', foreign_key: 'expression_id', touch: true
  belongs_to :realize_type, optional: true

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
#  id              :bigint           not null, primary key
#  agent_id        :bigint           not null
#  expression_id   :bigint           not null
#  position        :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  realize_type_id :integer
#
