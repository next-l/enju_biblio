require 'rails_helper'

describe PictureFile do
  # pending "add some examples to (or delete) #{__FILE__}"

end

# == Schema Information
#
# Table name: picture_files
#
#  id                      :bigint(8)        not null, primary key
#  picture_attachable_id   :bigint(8)        not null
#  picture_attachable_type :string           not null
#  content_type            :string
#  title                   :text
#  thumbnail               :string
#  position                :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  picture_file_name       :string
#  picture_content_type    :string
#  picture_file_size       :integer
#  picture_updated_at      :datetime
#  picture_meta            :text
#  picture_fingerprint     :string
#  picture_width           :integer
#  picture_height          :integer
#
