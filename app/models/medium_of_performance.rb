class MediumOfPerformance < ApplicationRecord
  include MasterModel
  has_many :works, class_name: 'Manifestation'
  translates :display_name
end

# == Schema Information
#
# Table name: medium_of_performances
#
#  id                        :integer          not null, primary key
#  name                      :string           not null
#  old_display_name          :text
#  note                      :text
#  position                  :integer
#  created_at                :datetime
#  updated_at                :datetime
#  display_name_translations :jsonb            not null
#
