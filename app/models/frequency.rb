class Frequency < ApplicationRecord
  include MasterModel
  default_scope { order('frequencies.position') }
  translates :display_name
  has_many :manifestations
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
