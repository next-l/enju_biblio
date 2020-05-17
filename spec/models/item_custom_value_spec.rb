require 'rails_helper'

RSpec.describe ItemCustomValue, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: item_custom_values
#
#  id                      :integer          not null, primary key
#  item_custom_property_id :integer          not null
#  item_id                 :integer          not null
#  value                   :text
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
