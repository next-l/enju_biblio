class MediumOfPerformance < ActiveRecord::Base
  include MasterModel
  has_many :works
  translates :display_name
end

# == Schema Information
#
# Table name: medium_of_performances
#
#  id                        :integer          not null, primary key
#  name                      :string           not null
#  display_name_translations :jsonb
#  note                      :text
#  position                  :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
