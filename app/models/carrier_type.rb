class CarrierType < ApplicationRecord
  include MasterModel
  has_many :manifestations
  has_one_attached :attachment
  translates :display_name

  def mods_type
    case name
    when 'volume'
      'text'
    else
      # TODO: その他のタイプ
      'software, multimedia'
    end
  end
end

# == Schema Information
#
# Table name: carrier_types
#
#  id                        :bigint           not null, primary key
#  name                      :string           not null
#  note                      :text
#  position                  :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  display_name_translations :jsonb            not null
#
