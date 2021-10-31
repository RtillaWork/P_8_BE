FactoryBot.define do
  factory :message do
    text { "MyText Message Message Message Message Message Message" }
    last_seen_at { "2021-06-27 11:41:52" }
    conversation { nil }
    user { nil }
  end
end
