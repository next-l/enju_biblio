class Periodical < ActiveRecord::Base
  has_many :manifestations
  belongs_to :manifestation

  validates :original_title, presence: true
  searchable do
    text :original_title
  end
end

# == Schema Information
#
# Table name: periodicals
#
#  id               :integer          not null, primary key
#  original_title   :text
#  periodical_type  :string
#  manifestation_id :uuid
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
