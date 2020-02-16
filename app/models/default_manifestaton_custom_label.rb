class DefaultManifestatonCustomLabel < ApplicationRecord
  belongs_to :library_group
  validates :label, presence: true, uniqueness: true
end

# == Schema Information
#
# Table name: default_manifestaton_custom_labels
#
#  id               :bigint           not null, primary key
#  library_group_id :bigint           not null
#  label            :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
