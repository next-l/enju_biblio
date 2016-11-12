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
#  series_statement_identifier        :string
#  manifestation_id                   :integer
#  note                               :text
#  title_subseries_transcription      :text
#  creator_string                     :text
#  volume_number_string               :text
#  volume_number_transcription_string :text
#  series_master                      :boolean
#  root_manifestation_id              :integer
#

module EnjuBiblio
  module SeriesStatementsHelper
    include ManifestationsHelper

    def series_pagination_link
      if flash[:manifestation_id]
        render 'manifestations/paginate_id_link', manifestation: Manifestation.find(flash[:manifestation_id])
      end
    end
  end
end
