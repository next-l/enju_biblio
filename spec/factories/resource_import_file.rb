FactoryBot.define do
  factory :resource_import_file, class: ResourceImportFile do
    association :user
  end
end
