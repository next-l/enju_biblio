class DoiRecord < ActiveRecord::Base
  belongs_to :manifestation
end

# == Schema Information
#
# Table name: doi_records
#
#  id                  :integer          not null, primary key
#  body                :string           not null
#  registration_agency :string
#  manifestation_id    :uuid
#  source              :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
