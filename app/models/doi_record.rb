class DoiRecord < ApplicationRecord
  belongs_to :manifestation
  validates :body, presence: true, uniqueness: true, format: {with: /\A[0-9]{2}\.[0-9]{2,}\/.+\Z/}
  before_save :normalize
  before_save :set_display_body

  strip_attributes

  def normalize
    url = URI.parse(body)
    if url.host =~ /doi\.org\Z/
      self.body = url.path.gsub(/\A\//, '').downcase
    else
      self.body = body.downcase
    end
  rescue URI::InvalidURIError
  end

  def set_display_body
    self.display_body = body unless display_body
  end
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
#  manifestation_id :bigint(8)        not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
