class License < ActiveRecord::Base
  include MasterModel
  translates :display_name
  default_scope { order('licenses.position') }
end

# == Schema Information
#
# Table name: licenses
#
#  id                        :bigint           not null, primary key
#  name                      :string           not null
#  display_name_translations :jsonb            not null
#  note                      :text
#  position                  :integer          default(1), not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
