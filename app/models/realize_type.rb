class RealizeType < ActiveRecord::Base
  include MasterModel
  default_scope { order('realize_types.position') }
end

# == Schema Information
#
# Table name: realize_types
#
#  id           :bigint(8)        not null, primary key
#  name         :string
#  display_name :text
#  note         :text
#  position     :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
