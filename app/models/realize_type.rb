class RealizeType < ActiveRecord::Base
  include MasterModel
  default_scope { order('realize_types.position') }
end

# == Schema Information
#
# Table name: realize_types
#
#  id           :integer          not null, primary key
#  name         :string           not null
#  display_name :text
#  note         :text
#  position     :integer          default(1), not null
#  created_at   :datetime
#  updated_at   :datetime
#
