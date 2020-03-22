module EnjuCirculation
  module EnjuLibraryGroup
    extend ActiveSupport::Concern

    included do
      has_many :custom_labels, dependent: :destroy
    end
  end
end
