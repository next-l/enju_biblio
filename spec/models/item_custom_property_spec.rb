require 'rails_helper'

RSpec.describe ItemCustomProperty, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: item_custom_properties
#
#  id           :integer          not null, primary key
#  name         :string           not null
#  display_name :text             not null
#  note         :text
#  position     :integer          default(1), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
