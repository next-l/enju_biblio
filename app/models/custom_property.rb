class CustomProperty < ApplicationRecord
  belongs_to :resource, polymorphic: true
  validates :label, presence: true
end

# == Schema Information
#
# Table name: custom_properties
#
#  id            :bigint           not null, primary key
#  resource_id   :integer          not null
#  resource_type :string           not null
#  label         :text             not null
#  value         :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
