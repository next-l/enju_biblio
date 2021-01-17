class Produce < ApplicationRecord
  belongs_to :agent
  belongs_to :manifestation, touch: true
  belongs_to :produce_type, optional: true
  delegate :original_title, to: :manifestation, prefix: true

  validates :manifestation_id, uniqueness: { scope: :agent_id }
  after_save :reindex
  after_destroy :reindex

  acts_as_list scope: :manifestation

  def reindex
    agent&.index
    manifestation&.index
  end
end

# == Schema Information
#
# Table name: produces
#
#  id               :bigint           not null, primary key
#  agent_id         :bigint           not null
#  manifestation_id :bigint           not null
#  position         :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  produce_type_id  :integer
#
