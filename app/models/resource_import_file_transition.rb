class ResourceImportFileTransition < ActiveRecord::Base
  include Statesman::Adapters::ActiveRecordTransition

  
  belongs_to :resource_import_file, inverse_of: :resource_import_file_transitions
end
