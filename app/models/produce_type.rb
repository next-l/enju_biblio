class ProduceType < ApplicationRecord
  include MasterModel
  default_scope { order('produce_types.position') }
  translates :display_name
end

# == Schema Information
#
# Table name: produce_types
#
#  id                        :integer          not null, primary key
#  name                      :string
#  display_name              :text
#  note                      :text
#  position                  :integer
#  created_at                :datetime
#  updated_at                :datetime
#  display_name_translations :jsonb            not null
#
