require 'rails_helper'

RSpec.describe CustomProperty, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: custom_properties
#
#  id            :integer          not null, primary key
#  resource_id   :integer          not null
#  resource_type :string           not null
#  label         :text             not null
#  value         :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
