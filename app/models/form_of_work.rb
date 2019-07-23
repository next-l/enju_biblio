class FormOfWork < ApplicationRecord
  include MasterModel
  default_scope { order('form_of_works.position') }
  translates :display_name
  has_many :works
end

# == Schema Information
#
# Table name: form_of_works
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
