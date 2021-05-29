class Frequency < ApplicationRecord
  include MasterModel
  has_many :manifestations, dependent: :restrict_with_exception
  translates :display_name
end

# == Schema Information
#
# Table name: frequencies
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
