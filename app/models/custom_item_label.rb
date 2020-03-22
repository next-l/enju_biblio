class CustomItemLabel < ApplicationRecord
  belongs_to :library_group
  has_many :custom_properties, as: :custom_label, dependent: :destroy
  validates :label, presence: true
end

# == Schema Information
#
# Table name: custom_item_labels
#
#  id               :bigint           not null, primary key
#  library_group_id :bigint           not null
#  label            :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
