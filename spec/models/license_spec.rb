require 'rails_helper'

describe License do
  # pending "add some examples to (or delete) #{__FILE__}"

end

# == Schema Information
#
# Table name: licenses
#
#  id           :bigint(8)        not null, primary key
#  name         :string           not null
#  display_name :jsonb            not null
#  note         :text
#  position     :integer          default(1), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
