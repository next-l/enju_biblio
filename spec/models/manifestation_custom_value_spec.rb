require 'rails_helper'

RSpec.describe ManifestationCustomValue, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: manifestation_custom_values
#
#  id                               :integer          not null, primary key
#  manifestation_custom_property_id :integer          not null
#  manifestation_id                 :integer          not null
#  value                            :text
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#
