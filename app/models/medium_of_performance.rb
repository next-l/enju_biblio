class MediumOfPerformance < ActiveRecord::Base
  include MasterModel
  include Mobility
  translates :display_name
  default_scope { order('medium_of_performances.position') }
  has_many :works
end

# == Schema Information
#
# Table name: medium_of_performances
#
#  id           :bigint(8)        not null, primary key
#  name         :string           not null
#  display_name :jsonb            not null
#  note         :text
#  position     :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
