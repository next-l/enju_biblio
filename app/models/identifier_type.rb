class IdentifierType < ActiveRecord::Base
  include MasterModel
  default_scope { order('identifier_types.position') }
  has_many :identifiers
  translates :display_name
  validates :name, format: { with: /\A[0-9a-z][0-9a-z_\-]*[0-9a-z]\Z/ }
end

# == Schema Information
#
# Table name: identifier_types
#
#  id                        :bigint           not null, primary key
#  name                      :string           not null
#  display_name_translations :jsonb            not null
#  note                      :text
#  position                  :integer          default(1), not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
