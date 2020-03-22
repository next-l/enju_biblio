class CustomProperty < ApplicationRecord
  belongs_to :custom_label, touch: true
  belongs_to :resource, polymorphic: true, touch: true
end

