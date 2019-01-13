class License < ActiveRecord::Base
  include MasterModel
  default_scope { order('licenses.position') }
end

# == Schema Information
#
# Table name: licenses
#
#  id           :bigint(8)        not null, primary key
#  name         :string           not null
#  display_name :string
#  note         :text
#  position     :integer          default(1), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
