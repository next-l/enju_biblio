class CreateType < ActiveRecord::Base
  include MasterModel
  default_scope { order('create_types.position') }
end

# == Schema Information
#
# Table name: create_types
#
#  id           :integer          not null, primary key
#  name         :string           not null
#  display_name :text
#  note         :text
#  position     :integer          default(1), not null
#  created_at   :datetime
#  updated_at   :datetime
#
