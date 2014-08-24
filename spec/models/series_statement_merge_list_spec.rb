require 'spec_helper'

describe SeriesStatementMergeList do
  fixtures :all

  it "should merge series_statment" do
    series_statement_merge_list = series_statement_merge_lists(:series_statement_merge_list_00001)
  end
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

