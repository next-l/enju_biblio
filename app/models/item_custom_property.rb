class ItemCustomProperty < ApplicationRecord
  include MasterModel
  validates :name, presence: true, uniqueness: true
  acts_as_list
  translates :display_name
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
