require 'rails_helper'

describe PictureFile do
  # pending "add some examples to (or delete) #{__FILE__}"

end

# == Schema Information
#
# Table name: picture_files
#
#  id                      :bigint           not null, primary key
#  picture_attachable_id   :bigint           not null
#  picture_attachable_type :string           not null
#  title                   :text
#  position                :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
