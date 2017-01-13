class CarrierType < ActiveRecord::Base
  #include MasterModel
  has_many :manifestations
  translates :display_name
  include AttachmentUploader[:attachment]

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
#  id                        :integer          not null, primary key
#  name                      :string           not null
#  display_name_translations :jsonb
#  note                      :text
#  position                  :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  attachment_id             :string
#  attachment_filename       :string
#  attachment_size           :integer
#  attachment_content_type   :string
#  attachment_data           :jsonb
#
