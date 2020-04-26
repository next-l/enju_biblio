class FormOfWork < ApplicationRecord
  include MasterModel
  has_many :works, class_name: 'Manifestation'
end

# == Schema Information
#
# Table name: form_of_works
#
#  id           :integer          not null, primary key
#  name         :string           not null
#  display_name :text
#  note         :text
#  position     :integer
#  created_at   :datetime
#  updated_at   :datetime
#
