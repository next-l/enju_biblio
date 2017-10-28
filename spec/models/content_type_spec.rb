
require 'rails_helper'

describe ContentType do
  # pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: content_types
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
