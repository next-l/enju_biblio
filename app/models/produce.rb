class Produce < ActiveRecord::Base
  belongs_to :agent
  belongs_to :manifestation, touch: true
  belongs_to :produce_type, optional: true
  delegate :original_title, to: :manifestation, prefix: true

  validates :manifestation, presence: true #, uniqueness: true
  after_save :reindex
  after_destroy :reindex

  acts_as_list scope: :manifestation
  translates :full_name

  def reindex
    manifestation.index
  end
end

# == Schema Information
#
# Table name: produces
#
#  id                     :bigint(8)        not null, primary key
#  agent_id               :uuid             not null
#  manifestation_id       :uuid             not null
#  position               :integer          default(1), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  produce_type_id        :integer
#  full_name_translations :jsonb
#
