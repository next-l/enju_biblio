class ProduceType < ActiveRecord::Base
  include MasterModel
  default_scope { order('produce_types.position') }
end

# == Schema Information
#
# Table name: produce_types
#
#  id           :bigint(8)        not null, primary key
#  name         :string
#  display_name :text
#  note         :text
#  position     :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
