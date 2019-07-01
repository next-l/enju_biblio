class FormOfWork < ActiveRecord::Base
  include MasterModel
  default_scope { order('form_of_works.position') }
  has_many :works
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
