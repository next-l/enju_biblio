class ProduceType < ApplicationRecord
  include MasterModel
end

# == Schema Information
#
# Table name: produce_types
#
#  id                        :bigint           not null, primary key
#  name                      :string
#  display_name              :text
#  note                      :text
#  position                  :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  display_name_translations :jsonb            not null
#
