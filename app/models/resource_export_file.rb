class ResourceExportFile < ActiveRecord::Base
  include Statesman::Adapters::ActiveRecordQueries
  include ExportFile

  has_one_attached :resource_export
  has_many :resource_export_file_transitions, autosave: false, dependent: :destroy

  def state_machine
    ResourceExportFileStateMachine.new(self, transition_class: ResourceExportFileTransition)
  end

  delegate :can_transition_to?, :transition_to!, :transition_to, :current_state,
    to: :state_machine

  def export!
    transition_to!(:started)
    role_name = user.try(:role).try(:name)
    tempfile = Tempfile.new(['resource_export_file_', '.txt'])
    tempfile.puts(Manifestation.csv_header(role_name, col_sep: "\t"))
    Manifestation.find_each do |manifestation|
      tempfile.puts(manifestation.to_csv(format: :txt, role: role_name))
    end
    tempfile.close
    self.resource_export.attach(io: File.new(tempfile.path, "r"), filename: "resource_export.txt")
    save!
    transition_to!(:completed)
    ResourceExportMailer.completed(self).deliver_later
  rescue => e
    transition_to!(:failed)
    ResourceExportMailer.failed(self).deliver_later
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
#  id          :bigint           not null, primary key
#  user_id     :bigint
#  executed_at :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
