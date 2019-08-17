class CustomItemProperty < ApplicationRecord
  belongs_to :item
end

# == Schema Information
#
# Table name: custom_item_properties
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  value      :text
#  item_id    :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
