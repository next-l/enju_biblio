require 'rails_helper'

RSpec.describe CustomManifestationLabel, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: custom_manifestation_labels
#
#  id               :bigint           not null, primary key
#  library_group_id :bigint           not null
#  label            :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
