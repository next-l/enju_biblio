class ManifestationRelationshipType < ApplicationRecord
  include MasterModel
  default_scope { order('manifestation_relationship_types.position') }
  has_many :manifestation_relationships
end

# == Schema Information
#
# Table name: manifestation_relationship_types
#
#  id                        :bigint           not null, primary key
#  name                      :string           not null
#  note                      :text
#  position                  :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  display_name_translations :jsonb            not null
#
