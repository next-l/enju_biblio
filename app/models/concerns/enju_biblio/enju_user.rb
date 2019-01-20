module EnjuBiblio
  module EnjuUser
    extend ActiveSupport::Concern

    included do
      has_many :import_requests
      has_many :picture_files, as: :picture_attachable, dependent: :destroy
    end
  end
end
