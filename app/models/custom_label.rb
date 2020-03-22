class CustomLabel < ApplicationRecord
  belongs_to :library_group
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
