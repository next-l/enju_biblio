require 'spec_helper'

describe SeriesStatement do
  fixtures :all

  it "should create manifestation" do
    series_statement = FactoryGirl.create(:series_statement)
    series_statement.manifestation.should be_true
    series_statement.reload
    series_statement.manifestation.series_statements.count.should eq 1
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
#  created_at                         :datetime         not null
#  updated_at                         :datetime         not null
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
#

