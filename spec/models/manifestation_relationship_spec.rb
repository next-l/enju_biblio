require 'rails_helper'

describe ManifestationRelationship do
  # pending "add some examples to (or delete) #{__FILE__}"

end

# == Schema Information
#
# Table name: manifestation_relationships
#
#  id                                 :bigint           not null, primary key
#  parent_id                          :bigint           not null
#  child_id                           :bigint           not null
#  manifestation_relationship_type_id :bigint           not null
#  created_at                         :datetime         not null
#  updated_at                         :datetime         not null
#  position                           :integer
#
