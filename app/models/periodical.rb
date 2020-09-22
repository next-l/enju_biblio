class Periodical < ApplicationRecord
  belongs_to :frequency
  has_many :periodical_and_manifestations, dependent: :destroy
  has_many :manifestations, through: :periodical_and_manifestations

  validates :original_title, presence: true

  searchable do
    string :original_title
    text :original_title
    text :publisher do
      periodical_and_manifestations.where(periodical_master: true).find_each do |a|
        a.manifestation.publishers.pluck(:full_name)
      end
    end
    text :issn do
      periodical_and_manifestations.where(periodical_master: true).find_each do |a|
        a.manifestation.issn_records.pluck(:body)
      end
    end
  end
end

# == Schema Information
#
# Table name: periodicals
#
#  id             :bigint           not null, primary key
#  original_title :text             not null
#  frequency_id   :bigint           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
