class MediumOfPerformance < ActiveRecord::Base
  include MasterModel
  has_many :works
end

# == Schema Information
#
# Table name: medium_of_performances
#
#  id           :integer          not null, primary key
#  name         :string           not null
#  display_name :text
#  note         :text
#  position     :integer
#  created_at   :datetime
#  updated_at   :datetime
#
