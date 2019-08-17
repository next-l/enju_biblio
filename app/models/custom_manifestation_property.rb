class CustomManifestationProperty < ApplicationRecord
  belongs_to :manifestation
end

# == Schema Information
#
# Table name: custom_manifestation_properties
#
#  id               :bigint           not null, primary key
#  name             :string           not null
#  value            :text
#  manifestation_id :bigint           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
