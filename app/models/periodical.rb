class Periodical < ActiveRecord::Base
  belongs_to :manifestation

  validates :original_title, presence: true
  searchable do
    text :original_title
  end
end
