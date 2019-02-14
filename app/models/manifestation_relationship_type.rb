class ManifestationRelationshipType < ActiveRecord::Base
  include MasterModel
  translates :display_name
  default_scope { order('manifestation_relationship_types.position') }
  has_many :manifestation_relationships
end

# == Schema Information
#
# Table name: manifestation_relationship_types
#
#  id                        :bigint(8)        not null, primary key
#  name                      :string           not null
#  display_name_translations :jsonb            not null
#  note                      :text
#  position                  :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
