class ProduceType < ApplicationRecord
  include MasterModel
  default_scope { order('produce_types.position') }
  translates :display_name
end

# == Schema Information
#
# Table name: produce_types
#
#  id                        :bigint           not null, primary key
#  name                      :string
#  note                      :text
#  position                  :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  display_name_translations :jsonb            not null
#
