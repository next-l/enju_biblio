require 'rails_helper'

RSpec.describe CustomLabel, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: custom_labels
#
#  id               :integer          not null, primary key
#  library_group_id :integer
#  label            :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
