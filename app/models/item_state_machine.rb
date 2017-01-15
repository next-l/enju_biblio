class ItemStateMachine
  include Statesman::Machine

  state :pending, initial: true
  state :available_on_shelf
  state :on_loan
  state :missing
  state :removed

  transition from: :pending, to: [:available_on_shelf, :on_loan, :missing, :removed]
  transition from: :available_on_shelf, to: [:on_loan, :missing, :removed]
end
