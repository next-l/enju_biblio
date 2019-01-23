class ResourceImportResult < ActiveRecord::Base
  default_scope { order('resource_import_results.id') }
  scope :file_id, proc{|file_id| where(resource_import_file_id: file_id)}
  scope :failed, -> { where(manifestation_id: nil) }
  scope :skipped, -> { where('error_message IS NOT NULL') }

  belongs_to :resource_import_file
  belongs_to :manifestation, optional: true
  belongs_to :item, optional: true

  validates_presence_of :resource_import_file_id
end

# == Schema Information
#
# Table name: resource_import_results
#
#  id                      :bigint(8)        not null, primary key
#  resource_import_file_id :bigint(8)
#  manifestation_id        :bigint(8)
#  item_id                 :uuid
#  body                    :text
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  error_message           :text
#
