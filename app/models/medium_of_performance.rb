class MediumOfPerformance < ActiveRecord::Base
  attr_accessible :name, :display_name, :note
  include MasterModel
  default_scope { order('medium_of_performances.position') }
  has_many :works
end

# == Schema Information
#
# Table name: medium_of_performances
#
#  id           :integer          not null, primary key
#  name         :string(255)      not null
#  display_name :text
#  note         :text
#  position     :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

