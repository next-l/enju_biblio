class ResourceExportFileTransition < ActiveRecord::Base
  include Statesman::Adapters::ActiveRecordTransition

  
  belongs_to :resource_export_file, inverse_of: :resource_export_file_transitions
  #attr_accessible :to_state, :sort_key, :metadata
end

# == Schema Information
#
# Table name: resource_export_file_transitions
#
#  id                      :integer          not null, primary key
#  to_state                :string
#  metadata                :text             default({})
#  sort_key                :integer
#  resource_export_file_id :integer
#  created_at              :datetime
#  updated_at              :datetime
#  most_recent             :boolean
#
