class CustomProperty < ApplicationRecord
  belongs_to :custom_label, polymorphic: true, touch: true
  belongs_to :resource, polymorphic: true, touch: true
  validates :value, presence: true
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
