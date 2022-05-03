FactoryBot.define do
  factory :conversation do
    is_active { true }
    # task { nil }
    task { FactoryBot.build(:task) }
    # user { nil }
    user { FactoryBot.build(:user) }
  end
end
