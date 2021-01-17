FactoryBot.define do
  factory :reserve do
    before(:create) do |reserve|
      profile = FactoryBot.create(:profile)
      user = FactoryBot.create(:admin)
      user.profile = profile
      reserve.user = user
    end
    manifestation_id{FactoryBot.create(:manifestation).id}
    # user{FactoryBot.create(:user)}
  end
end
