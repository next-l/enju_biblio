class Create < ApplicationRecord
  belongs_to :agent
  belongs_to :work, class_name: 'Manifestation', foreign_key: 'work_id', touch: true
  belongs_to :create_type, optional: true

  validates :work_id, uniqueness: { scope: :agent_id }
  after_save :reindex
  after_destroy :reindex

  acts_as_list scope: :work

  def reindex
    agent&.index
    work&.index
  end
end

# == Schema Information
#
# Table name: creates
#
#  id             :bigint           not null, primary key
#  agent_id       :bigint           not null
#  work_id        :bigint           not null
#  position       :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  create_type_id :integer
#
