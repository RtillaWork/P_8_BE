FactoryBot.define do 
  factory :volunteer do
   email   { "testvolunteer#{Faker::Name.first_name_neutral}@m.co" } #{ "testfactorybotuser@m.co" }
   first_name { Faker::Name.first_name } 
   last_name { Faker::Name.last_name } 
   preferred_name { Faker::Name.first_name_neutral }
   address { Faker::Address.street_address }
   avatar { Faker::Avatar.image }
   default_lat { rand(-24.1000000..-23.4000000) }
   default_lng { rand(-47.8000000..-46.4000000) }
   last_loggedin {  Time.now }
   last_active { Time.now+3600 }
   password { "vvvvvv" } 
   password_confirmation { "vvvvvv" }
  end
 
end