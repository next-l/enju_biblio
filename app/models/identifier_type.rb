class IdentifierType < ActiveRecord::Base
  attr_accessible :display_name, :name, :note, :position
  include MasterModel
  default_scope :order => "identifier_types.position"
  has_many :manifestations
  has_many :identifiers
end

# == Schema Information
#
# Table name: identifier_types
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  display_name :text
#  note         :text
#  position     :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

