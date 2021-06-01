class ContentType < ApplicationRecord
  include MasterModel
  has_many :manifestations
  translates :display_name
end

# == Schema Information
#
# Table name: content_types
#
#  id                        :bigint           not null, primary key
#  name                      :string           not null
#  note                      :text
#  position                  :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  display_name_translations :jsonb            not null
#
