# -*- encoding: utf-8 -*-
require 'rails_helper'

describe PictureFile do
  #pending "add some examples to (or delete) #{__FILE__}"

end

# == Schema Information
#
# Table name: picture_files
#
#  id                      :integer          not null, primary key
#  picture_attachable_id   :integer
#  picture_attachable_type :string
#  content_type            :string
#  title                   :text
#  thumbnail               :string
#  position                :integer
#  created_at              :datetime
#  updated_at              :datetime
#  picture_meta            :text
#  picture_fingerprint     :string
#  image_data              :jsonb
#
