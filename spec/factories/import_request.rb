FactoryBot.define do
  factory :import_request do
    sequence(:isbn){|n| "isbn_#{n}"}
    association :user, factory: :librarian
  end
end
