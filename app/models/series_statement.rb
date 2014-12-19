class SeriesStatement < ActiveRecord::Base
  has_many :series_statement_merges, dependent: :destroy
  has_many :series_statement_merge_lists, through: :series_statement_merges
  belongs_to :manifestation, touch: true
  belongs_to :root_manifestation, foreign_key: :root_manifestation_id, class_name: 'Manifestation', touch: true
  validates_presence_of :original_title
  before_save :create_root_series_statement

  acts_as_list
  searchable do
    text :title do
      titles
    end
    text :numbering, :title_subseries, :numbering_subseries
    integer :manifestation_id
    integer :position
    integer :series_statement_merge_list_ids, multiple: true
  end

  attr_accessor :selected
  normalize_attributes :original_title

  paginates_per 10

  def titles
    [
      original_title,
      title_transcription
    ]
  end

  def create_root_series_statement
    if series_master? && root_manifestation.nil?
      self.root_manifestation = manifestation
    else
      self.root_manifestation = nil
    end
  end
end

# == Schema Information
#
# Table name: series_statements
#
#  id                                 :integer          not null, primary key
#  original_title                     :text
#  numbering                          :text
#  title_subseries                    :text
#  numbering_subseries                :text
#  position                           :integer
#  created_at                         :datetime
#  updated_at                         :datetime
#  title_transcription                :text
#  title_alternative                  :text
#  series_statement_identifier        :string(255)
#  manifestation_id                   :integer
#  note                               :text
#  title_subseries_transcription      :text
#  creator_string                     :text
#  volume_number_string               :text
#  volume_number_transcription_string :text
#  series_master                      :boolean
#  root_manifestation_id              :integer
#
