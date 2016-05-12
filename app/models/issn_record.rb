class IssnRecord < ActiveRecord::Base
  belongs_to :manifestation
  validates :body, presence: true, uniqueness: {scope: :issn_type}
end
