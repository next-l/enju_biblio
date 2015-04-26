class CarrierType < ActiveRecord::Base
  include MasterModel
  default_scope { order("carrier_types.position") }
  has_many :manifestations
  enju_circulation_carrier_type_model if defined?(EnjuCirculation)
  attachment :attachment

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
#  id                      :integer          not null, primary key
#  name                    :string           not null
#  display_name            :text
#  note                    :text
#  position                :integer
#  created_at              :datetime
#  updated_at              :datetime
#  attachment_id           :string
#  attachment_filename     :string
#  attachment_size         :integer
#  attachment_content_type :string
#
