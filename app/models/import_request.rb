class ImportRequest < ActiveRecord::Base
  default_scope {order('import_requests.id DESC')}
  belongs_to :manifestation
  belongs_to :user
  validates_presence_of :isbn
  validate :check_isbn
  #validate :check_imported, :on => :create
  #validates_uniqueness_of :isbn, :if => Proc.new{|request| ImportRequest.where("created_at > ?", 1.day.ago).collect(&:isbn).include?(request.isbn)}
  enju_ndl_ndl_search if defined?(EnjuNdl)
  enju_nii_cinii_books if defined?(EnjuNii)

  state_machine :initial => :pending do
    event :sm_fail do
      transition :pending => :failed
    end

    event :sm_complete do
      transition :pending => :completed
    end
  end

  def check_isbn
    if isbn.present?
      errors.add(:isbn) unless StdNum::ISBN.valid?(isbn)
    end
  end

  def check_imported
    if isbn.present?
      if Manifestation.where(:isbn => isbn).first
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
        sm_complete!
        manifestation.index!
      else
        sm_fail!
      end
    else
      sm_fail!
    end
  rescue ActiveRecord::RecordInvalid
    sm_fail!
  rescue NameError
    sm_fail!
  rescue EnjuNdl::RecordNotFound
    sm_fail!
  #rescue EnjuNii::RecordNotFound
  #  sm_fail!
  end
end

# == Schema Information
#
# Table name: import_requests
#
#  id               :integer          not null, primary key
#  isbn             :string(255)
#  state            :string(255)
#  manifestation_id :integer
#  user_id          :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

