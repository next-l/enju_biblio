
require 'rails_helper'

describe ManifestationRelationship do
  # pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: manifestation_relationships
#
#  id                                 :integer          not null, primary key
#  parent_id                          :uuid
#  child_id                           :uuid
#  manifestation_relationship_type_id :integer
#  created_at                         :datetime         not null
#  updated_at                         :datetime         not null
#  position                           :integer
#
