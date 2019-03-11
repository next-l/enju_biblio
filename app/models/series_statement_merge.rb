class SeriesStatementMerge < ActiveRecord::Base
  belongs_to :series_statement
  belongs_to :series_statement_merge_list
  validates_presence_of :series_statement, :series_statement_merge_list
  validates_associated :series_statement, :series_statement_merge_list

  paginates_per 10
end

# == Schema Information
#
# Table name: series_statement_merges
#
#  id                             :bigint(8)        not null, primary key
#  series_statement_id            :uuid             not null
#  series_statement_merge_list_id :uuid             not null
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#
