class MediumOfPerformance < ApplicationRecord
  include MasterModel
  has_many :works
end

# == Schema Information
#
# Table name: medium_of_performances
#
#  id                        :integer          not null, primary key
#  name                      :string           not null
#  display_name              :text
#  note                      :text
#  position                  :integer
#  created_at                :datetime
#  updated_at                :datetime
#  display_name_translations :jsonb            not null
#
