class Create < ActiveRecord::Base
  belongs_to :agent
  belongs_to :work, class_name: 'Manifestation', foreign_key: 'work_id', touch: true
  belongs_to :create_type, optional: true

  validates :work_id, presence: true #, uniqueness: true
  after_save :reindex
  after_destroy :reindex

  acts_as_list scope: :work
  translates :full_name

  def reindex
    work.index
  end
end

# == Schema Information
#
# Table name: creates
#
#  id                     :bigint(8)        not null, primary key
#  agent_id               :uuid             not null
#  work_id                :uuid             not null
#  position               :integer          default(1), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  create_type_id         :integer
#  full_name_translations :jsonb
#
