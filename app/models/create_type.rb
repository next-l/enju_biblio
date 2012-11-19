class CreateType < ActiveRecord::Base
  attr_accessible :name, :display_name, :note, :position
  include MasterModel
  default_scope :order => 'create_types.position'
end

# == Schema Information
#
# Table name: create_types
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  display_name :text
#  note         :text
#  position     :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

