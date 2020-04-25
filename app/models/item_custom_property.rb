class ItemCustomProperty < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  translates :display_name
  acts_as_list
end

# == Schema Information
#
# Table name: item_custom_properties
#
#  id                        :bigint           not null, primary key
#  name                      :string           not null
#  display_name_translations :jsonb            not null
#  note                      :text
#  position                  :integer          default(1), not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
