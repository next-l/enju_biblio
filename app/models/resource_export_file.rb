class ResourceExportFile < ActiveRecord::Base
  include Statesman::Adapters::ActiveRecordQueries
  include ExportFile
  enju_export_file_model

  #validates_attachment_content_type :resource_export, content_type: /\Atext\/plain\Z/
  attachment :resource_export

  has_many :resource_export_file_transitions

  def state_machine
    ResourceExportFileStateMachine.new(self, transition_class: ResourceExportFileTransition)
  end

  delegate :can_transition_to?, :transition_to!, :transition_to, :current_state,
    to: :state_machine

  def export!
    transition_to!(:started)
    tempfile = Tempfile.new(['resource_export_file_', '.txt'])
    file = Manifestation.export(format: :txt)
    tempfile.puts(file)
    tempfile.close
    self.resource_export = File.new(tempfile.path, "r")
    if save
      send_message
    end
    transition_to!(:completed)
  rescue => e
    transition_to!(:failed)
    raise e
  end

  private
  def self.transition_class
    ResourceExportFileTransition
  end

  def self.initial_state
    :pending
  end
end

# == Schema Information
#
# Table name: resource_export_files
#
#  id                       :integer          not null, primary key
#  user_id                  :integer
#  executed_at              :datetime
#  created_at               :datetime
#  updated_at               :datetime
#  resource_export_id       :string
#  resource_export_size     :integer
#  resource_export_filename :string
#
