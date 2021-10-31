FactoryBot.define do
  factory :task do 
   title {  "Title by requestor Can you please help" }
    description { "Description: #{Faker::Lorem.paragraphs.join}" }
    kind { 'OTT' }
    is_published { true }
    unpublished_at { nil } #{ "2021-06-27 11:43:28" }
    is_fullfilled { false }
    lat { -23.550520 + rand(-0.01..0.01) }
    lng { -46.633309 + rand(-0.01..0.01) }
    # user { nil }
    # user { FactoryBot.create(:user)}
    user { FactoryBot.build(:user, :requestor)}
  end
end


  # factory :task do 
  #  title {  "Title by requestor Can you please help" }
  #   description { "Description: #{Faker::Lorem.paragraphs.join}" }
  #   kind { 'OTT' }
  #   is_published { true }
  #   unpublished_at { nil } #{ "2021-06-27 11:43:28" }
  #   is_fullfilled { false }
  #   lat { -23.550520 + rand(-0.01..0.01) }
  #   lng { -46.633309 + rand(-0.01..0.01) }
  #   # user { nil }
  #   # user { FactoryBot.create(:user)}
  #       user { FactoryBot.build(:requestor)}
  # end



# FactoryBot.define do
#   factory :invalid_task_kind do 
#    title {  "Title by requestor Can you please help" }
#     description { "Description: #{Faker::Lorem.paragraphs.join}" }
#     kind { 'INVALID' }
#     is_published { true }
#     unpublished_at { nil } #{ "2021-06-27 11:43:28" }
#     is_fullfilled { false }
#     lat { -23.550520 + rand(-0.01..0.01) }
#     lng { -46.633309 + rand(-0.01..0.01) }
#     user { nil }
#     # user { FactoryBot.create(:user) }
#   end
# end


# FactoryBot.define do
#   factory :task do
#     title { "MyString" }
#     description { "MyText" }
#     kind { "MyString" }
#     is_published { false }
#     unpublished_at { "2021-06-27 11:43:28" }
#     is_fullfilled { false }
#     lat { 1.5 }
#     lng { 1.5 }
#     user { nil }
#   end
# end

# FactoryBot.define do
#   factory :task do
#     title { "MyString Title" }
#     description { "MyText DescriptionDescriptionDescriptionDescriptionDescriptionDescription" }
#     kind { "MyString" }
#     is_published { true }
#     unpublished_at { "2021-06-27 11:43:28" }
#     is_fullfilled { false }
#     lat { 1.5 }
#     lng { 1.5 }
#     # user { nil }
#     user { :user }
#   end
# end
