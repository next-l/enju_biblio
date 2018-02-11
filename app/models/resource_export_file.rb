class ResourceExportFile < ActiveRecord::Base
  include Statesman::Adapters::ActiveRecordQueries
  include ExportFile
  has_one_attached :attachment

  has_many :resource_export_file_transitions

  def state_machine
    ResourceExportFileStateMachine.new(self, transition_class: ResourceExportFileTransition)
  end

  delegate :can_transition_to?, :transition_to!, :transition_to, :current_state,
    to: :state_machine

  def export!
    transition_to!(:started)
    tempfile = Tempfile.new(['resource_export_file_', '.txt'])
    tempfile.puts(Manifestation.csv_header(col_sep: "\t"))
    Manifestation.find_each do |manifestation|
      tempfile.puts(manifestation.to_csv(format: :txt))
    end
    tempfile.close
    self.attachment = File.new(tempfile.path, "r")
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
#  id              :integer          not null, primary key
#  user_id         :integer
#  executed_at     :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  attachment_data :jsonb
#
