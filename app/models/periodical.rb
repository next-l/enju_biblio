class Periodical < ActiveRecord::Base
  has_many :manifestations
  belongs_to :manifestation

  validates :original_title, presence: true
  searchable do
    text :original_title
  end
end
