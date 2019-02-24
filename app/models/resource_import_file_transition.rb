class ResourceImportFileTransition < ActiveRecord::Base

  
  belongs_to :resource_import_file, inverse_of: :resource_import_file_transitions
  #attr_accessible :to_state, :sort_key, :metadata
end

# == Schema Information
#
# Table name: resource_import_file_transitions
#
#  id                      :bigint(8)        not null, primary key
#  to_state                :string
#  metadata                :jsonb
#  sort_key                :integer
#  resource_import_file_id :uuid
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  most_recent             :boolean          not null
#
