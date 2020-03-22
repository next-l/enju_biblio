FactoryBot.define do
  factory :custom_label do
    sequence(:label){|n| "custom label #{n}"}
    library_group_id { LibraryGroup.first.id }
  end
end
