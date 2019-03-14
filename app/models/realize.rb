class Realize < ActiveRecord::Base
  belongs_to :agent
  belongs_to :expression, class_name: 'Manifestation', foreign_key: 'expression_id', touch: true
  belongs_to :realize_type, optional: true

  validates :expression_id, presence: true #, uniqueness: true
  after_save :reindex
  after_destroy :reindex

  acts_as_list scope: :expression
  translates :full_name

  def reindex
    expression.index
  end
end

# == Schema Information
#
# Table name: realizes
#
#  id                     :bigint(8)        not null, primary key
#  agent_id               :uuid             not null
#  expression_id          :uuid             not null
#  position               :integer          default(1), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  realize_type_id        :integer
#  full_name_translations :jsonb
#
