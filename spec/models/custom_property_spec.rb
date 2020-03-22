require 'rails_helper'

RSpec.describe CustomProperty, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: custom_properties
#
#  id                :bigint           not null, primary key
#  custom_label_type :string           not null
#  custom_label_id   :bigint           not null
#  resource_type     :string           not null
#  resource_id       :bigint           not null
#  value             :text             not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
