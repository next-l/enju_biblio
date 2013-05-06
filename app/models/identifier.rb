class Identifier < ActiveRecord::Base
  attr_accessible :body, :identifier_type_id, :manifestation_id, :primary
  belongs_to :identifier_type
  belongs_to :manifestation

  validates_uniqueness_of :body, :scope => [:identifier_type_id, :manifestation_id]
end

# == Schema Information
#
# Table name: identifiers
#
#  id                 :integer          not null, primary key
#  body               :string(255)
#  identifier_type_id :integer
#  manifestation_id   :integer
#  primary            :boolean
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

