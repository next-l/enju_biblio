class SeriesStatementMergeList < ActiveRecord::Base
  has_many :series_statement_merges, dependent: :destroy
  has_many :series_statements, through: :series_statement_merges
  validates_presence_of :title

  paginates_per 10
end

# == Schema Information
#
# Table name: series_statement_merge_lists
#
#  id         :bigint(8)        not null, primary key
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
