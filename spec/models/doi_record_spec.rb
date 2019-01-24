require 'rails_helper'

RSpec.describe DoiRecord, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: doi_records
#
#  id               :bigint(8)        not null, primary key
#  body             :string           not null
#  display_body     :string           not null
#  source           :string
#  response         :jsonb            not null
#  manifestation_id :uuid             not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
