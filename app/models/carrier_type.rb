class CarrierType < ActiveRecord::Base
  include MasterModel
  include Mobility
  translates :display_name
  default_scope { order("carrier_types.position") }
  has_many :manifestations
  has_one_attached :attachment

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
#  id                      :bigint(8)        not null, primary key
#  name                    :string           not null
#  display_name            :jsonb            not null
#  note                    :text
#  position                :integer          default(1), not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  attachment_file_name    :string
#  attachment_content_type :string
#  attachment_file_size    :bigint(8)
#  attachment_updated_at   :datetime
#
