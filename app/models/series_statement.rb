class SeriesStatement < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  belongs_to :manifestation, touch: true
  belongs_to :root_manifestation, :foreign_key => :root_manifestation_id, :class_name => 'Manifestation'
  validates_presence_of :original_title
  before_save :create_root_series_statement

  acts_as_list

  index_name "#{name.downcase.pluralize}-#{Rails.env}"

  after_commit on: :create do
    index_document
  end

  after_commit on: :update do
    update_document
  end

  after_commit on: :destroy do
    delete_document
  end

  settings do
    mappings dynamic: 'false', _routing: {required: false} do
      indexes :title
      indexes :numbering
      indexes :title_subseries
      indexes :numbering_subseries
      indexes :manifestation_id, type: 'integer'
      indexes :position, type: 'integer'
      indexes :series_statement_merge_list_ids, type: 'integer' if defined?(EnjuResourceMerge)
    end
  end

  def as_indexed_json(options={})
    as_json.merge(
      title: titles
    )
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
    if series_master? and root_manifestation.nil?
      self.root_manifestation = manifestation
    end
  end

  if defined?(EnjuResourceMerge)
    has_many :series_statement_merges, :dependent => :destroy
    has_many :series_statement_merge_lists, :through => :series_statement_merges
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
