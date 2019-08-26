require 'rails_helper'

describe PictureFile do
  # pending "add some examples to (or delete) #{__FILE__}"

end

# == Schema Information
#
# Table name: picture_files
#
#  id                      :bigint           not null, primary key
#  picture_attachable_id   :integer
#  picture_attachable_type :string
#  content_type            :string
#  title                   :text
#  thumbnail               :string
#  position                :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
