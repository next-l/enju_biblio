class ResourceExportFileTransition < ActiveRecord::Base
  include Statesman::Adapters::ActiveRecordTransition

  
  belongs_to :resource_export_file, inverse_of: :resource_export_file_transitions
  attr_accessible :to_state, :sort_key, :metadata
end
