require 'rails_helper'

RSpec.describe CustomProperty, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: custom_properties
#
#  id                       :bigint           not null, primary key
#  name                     :string           not null
#  value                    :text
#  property_attachable_id   :integer          not null
#  property_attachable_type :string           not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
