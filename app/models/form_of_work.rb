class FormOfWork < ApplicationRecord
  include MasterModel
  has_many :works, class_name: 'Manifestation' # , dependent: :restrict_with_exception
  translates :display_name
end

# == Schema Information
#
# Table name: form_of_works
#
#  id                        :bigint           not null, primary key
#  name                      :string           not null
#  note                      :text
#  position                  :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  display_name_translations :jsonb            not null
#
