class Own < ApplicationRecord
  belongs_to :agent
  belongs_to :item

  validates :item_id, uniqueness: { scope: :agent_id }
  after_save :reindex
  after_destroy :reindex

  acts_as_list scope: :item

  attr_accessor :item_identifier

  def reindex
    agent&.index
    item&.index
  end
end

# == Schema Information
#
# Table name: owns
#
#  id         :bigint           not null, primary key
#  agent_id   :bigint           not null
#  item_id    :bigint           not null
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
