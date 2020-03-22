class CustomProperty < ApplicationRecord
  belongs_to :custom_label, touch: true
  belongs_to :resource, polymorphic: true, touch: true
end

# == Schema Information
#
# Table name: custom_properties
#
#  id              :integer          not null, primary key
#  resource_id     :integer          not null
#  resource_type   :string           not null
#  custom_label_id :integer          not null
#  value           :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
