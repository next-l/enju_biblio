class SeriesStatementMergeList < ActiveRecord::Base
  attr_accessible :title
  has_many :series_statement_merges, dependent: :destroy
  has_many :series_statements, through: :series_statement_merges
  validates_presence_of :title

  paginates_per 10
end

# == Schema Information
#
# Table name: series_statement_merge_lists
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

