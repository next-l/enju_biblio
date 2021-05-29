class License < ApplicationRecord
  include MasterModel
  translates :display_name
end

# == Schema Information
#
# Table name: licenses
#
#  id                        :integer          not null, primary key
#  name                      :string           not null
#  old_display_name          :string
#  note                      :text
#  position                  :integer
#  created_at                :datetime
#  updated_at                :datetime
#  display_name_translations :jsonb            not null
#
