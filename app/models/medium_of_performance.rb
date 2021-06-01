class MediumOfPerformance < ApplicationRecord
  include MasterModel
  has_many :works, class_name: 'Manifestation'
  translates :display_name
end

# == Schema Information
#
# Table name: medium_of_performances
#
#  id                        :bigint           not null, primary key
#  name                      :string           not null
#  note                      :text
#  position                  :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  display_name_translations :jsonb            not null
#
