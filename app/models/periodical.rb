class Periodical < ActiveRecord::Base
  has_many :manifestations
  belongs_to :manifestation
  belongs_to :frequency

  validates :original_title, presence: true

  before_create :create_master

  searchable do
    string :original_title
    text :original_title
    text :publisher do
      manifestation.publishers.pluck(:full_name) if manifestation
    end
    text :issn do
      manifestation.issn_records.pluck(:body) if manifestation
    end
  end

  def create_master
    unless manifestation
      self.manifestation = Manifestation.new(
        original_title: original_title,
        required_role_id: 3
      )
    end
  end
end
