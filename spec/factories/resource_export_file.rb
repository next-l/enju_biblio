FactoryBot.define do
  factory :resource_export_file, class: ResourceExportFile do
    association :user
  end
end
