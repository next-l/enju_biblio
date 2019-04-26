class ImportRequest < ActiveRecord::Base
  include Statesman::Adapters::ActiveRecordQueries
  default_scope { order('import_requests.id DESC') }
  belongs_to :manifestation, optional: true
  belongs_to :user
  validates_presence_of :isbn
  validate :check_isbn
  #validate :check_imported, on: :create
  #validates_uniqueness_of :isbn, if: Proc.new{|request| ImportRequest.where("created_at > ?", 1.day.ago).collect(&:isbn).include?(request.isbn)}

  has_many :import_request_transitions, autosave: false

  def state_machine
    ImportRequestStateMachine.new(self, transition_class: ImportRequestTransition)
  end

  delegate :can_transition_to?, :transition_to!, :transition_to, :current_state,
    to: :state_machine

  def check_isbn
    if isbn.present?
      errors.add(:isbn) unless StdNum::ISBN.valid?(isbn)
    end
  end

  def check_imported
    if isbn.present?
      if IsbnRecord.find_by(body: isbn)
        errors.add(:isbn, I18n.t('import_request.isbn_taken'))
      end
    end
  end

  def import!
    exceptions = [ ActiveRecord::RecordInvalid, NameError, URI::InvalidURIError ]
    not_found_exceptions = []
    not_found_exceptions << EnjuNdl::RecordNotFound if defined? EnjuNdl
    not_found_exceptions << EnjuNii::RecordNotFound if defined? EnjuNii
    begin
      return nil unless Manifestation.respond_to?(:import_isbn)
      unless manifestation
        manifestation = Manifestation.import_isbn(isbn)
        if manifestation
          self.manifestation = manifestation
          transition_to!(:completed)
          manifestation.index
          Sunspot.commit
        else
          transition_to!(:failed)
        end
      end
      save
    rescue *not_found_exceptions => e
      transition_to!(:failed)
      return :record_not_found
    rescue *exceptions => e
      transition_to!(:failed)
      return :error
    end
  end

  private
  def self.transition_class
    ImportRequestTransition
  end

  def self.initial_state
    :pending
  end
end

# == Schema Information
#
# Table name: import_requests
#
#  id               :bigint(8)        not null, primary key
#  isbn             :string           not null
#  manifestation_id :bigint(8)
#  user_id          :bigint(8)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
