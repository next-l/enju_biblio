FactoryBot.define do
  factory :resource_import_result, class: ResourceImportResult do
    association :resource_import_file
  end
end
