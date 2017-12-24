FactoryBot.define do
  factory :role, :class => Role do |f|
    f.sequence(:name) do |n|
      idx = "a"
      n.times{ idx = idx.next }
      "name#{idx}"
    end
  end
end
