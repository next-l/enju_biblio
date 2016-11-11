class ContentType < ActiveRecord::Base
  include MasterModel
  has_many :manifestations
  include AttachmentUploader[:attachment]
end

# == Schema Information
#
# Table name: content_types
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
