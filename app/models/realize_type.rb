class RealizeType < ApplicationRecord
  include MasterModel
  default_scope { order('realize_types.position') }
  translates :display_name
end

# == Schema Information
#
# Table name: realize_types
#
#  id                        :bigint           not null, primary key
#  name                      :string
#  note                      :text
#  position                  :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  display_name_translations :jsonb            not null
#
