class ResourceExportFileStateMachine
  include Statesman::Machine

  state :pending, initial: true
  state :started
  state :completed
  state :failed

  transition from: :pending, to: :started
  transition from: :started, to: [:completed, :failed]

  before_transition(from: :pending, to: :started) do |resource_export_file|
    resource_export_file.executed_at = Time.zone.now
  end

  before_transition(from: :started, to: :completed) do |resource_export_file|
    resource_export_file.error_message = nil
  end
end
