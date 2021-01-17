FactoryBot.define do
  factory :manifestation do
    sequence(:original_title){|n| "manifestation_title_#{n}"}
    sequence(:manifestation_identifier){|n| "identifier_#{n}"}
    carrier_type_id{CarrierType.find(1).id}

    after(:build) do |manifestation|
      manifestation.creators << FactoryBot.build(:agent)
    end
  end

  factory :manifestation_serial, class: Manifestation do
    sequence(:original_title){|n| "manifestation_title_#{n}"}
    carrier_type_id{CarrierType.find(1).id}
    language_id{Language.find(1).id}
    serial{true}

    after(:build) do |manifestation|
      manifestation.series_statements << FactoryBot.create(:series_statement_serial)
    end
  end

  trait :with_item do
    after(:build) do |manifestation|
      manifestation.items << FactoryBot.build(:item)
    end
  end

  trait :with_contributor do
    after(:build) do |manifestation|
      manifestation.contributors << FactoryBot.build(:agent)
    end
  end

  trait :with_publisher do
    after(:build) do |manifestation|
      manifestation.publishers << FactoryBot.build(:agent)
    end
  end

  trait :with_subject do
    after(:build) do |manifestation|
      manifestation.subjects << FactoryBot.build(:subject)
    end
  end
end
