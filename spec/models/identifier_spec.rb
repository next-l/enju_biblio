require 'rails_helper'

describe Identifier do
  # pending "add some examples to (or delete) #{__FILE__}"

end

# == Schema Information
#
# Table name: identifiers
#
#  id                 :bigint(8)        not null, primary key
#  body               :string           not null
#  identifier_type_id :integer          not null
#  manifestation_id   :uuid             not null
#  primary            :boolean
#  position           :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
