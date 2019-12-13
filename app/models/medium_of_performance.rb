class MediumOfPerformance < ApplicationRecord
  include MasterModel
  default_scope { order('medium_of_performances.position') }
  translates :display_name
  has_many :works, class_name: 'Manifestation'
end

# == Schema Information
#
# Table name: medium_of_performances
#
#  id                        :bigint           not null, primary key
#  name                      :string           not null
#  display_name              :text
#  note                      :text
#  position                  :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  display_name_translations :jsonb            not null
#
