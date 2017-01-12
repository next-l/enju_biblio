class IsbnRecord < ActiveRecord::Base
  belongs_to :manifestation
end

# == Schema Information
#
# Table name: isbn_records
#
#  id               :integer          not null, primary key
#  body             :string           not null
#  isbn_type        :string
#  source           :string
#  manifestation_id :uuid
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
