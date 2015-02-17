class ImportRequest < ActiveRecord::Base
  include Statesman::Adapters::ActiveRecordQueries
  belongs_to :manifestation
  belongs_to :user
  validates_presence_of :isbn
  validate :check_isbn
  #validate :check_imported, on: :create
  #validates_uniqueness_of :isbn, if: Proc.new{|request| ImportRequest.where("created_at > ?", 1.day.ago).collect(&:isbn).include?(request.isbn)}
  enju_ndl_ndl_search if defined?(EnjuNdl)
  enju_nii_cinii_books if defined?(EnjuNii)

  has_many :import_request_transitions

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
      identifier_type = IdentifierType.where(name: 'isbn').first
      identifier_type = IdentifierType.where(name: 'isbn').create! unless identifier_type
      if Identifier.where(body: isbn, identifier_type_id: identifier_type.id).first.try(:manifestation)
        errors.add(:isbn, I18n.t('import_request.isbn_taken'))
      end
    end
  end

  def import!
    return nil unless Manifestation.respond_to?(:import_isbn)
    unless manifestation
      manifestation = Manifestation.import_isbn(isbn)
      if manifestation
        self.manifestation = manifestation
        transition_to!(:completed)
        manifestation.index!
      else
        transition_to!(:failed)
      end
    #else
    #  transition_to!(:failed)
    end
    save
  rescue ActiveRecord::RecordInvalid
    transition_to!(:failed)
  rescue NameError
    transition_to!(:failed)
  rescue EnjuNdl::RecordNotFound
    transition_to!(:failed)
  rescue EnjuNii::RecordNotFound
    transition_to!(:failed)
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
#  id               :integer          not null, primary key
#  isbn             :string(255)
#  manifestation_id :integer
#  user_id          :integer
#  created_at       :datetime
#  updated_at       :datetime
#
