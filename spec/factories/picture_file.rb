FactoryBot.define do
  factory :picture_file, class: PictureFile do
    association :picture_attachable, factory: :manifestation
  end
end
