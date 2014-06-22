class ImportRequestTransition < ActiveRecord::Base
  include Statesman::Adapters::ActiveRecordTransition

  
  belongs_to :import_request, inverse_of: :import_request_transitions
  attr_accessible :to_state, :sort_key, :metadata
end
