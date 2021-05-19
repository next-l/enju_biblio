class ManifestationRelationshipType < ApplicationRecord
  include MasterModel
  default_scope { order('manifestation_relationship_types.position') }
  has_many :manifestation_relationships
end

# == Schema Information
#
# Table name: manifestation_relationship_types
#
#  id                        :integer          not null, primary key
#  name                      :string           not null
#  display_name              :text
#  note                      :text
#  position                  :integer
#  created_at                :datetime
#  updated_at                :datetime
#  display_name_translations :jsonb            not null
#
