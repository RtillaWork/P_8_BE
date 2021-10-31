FactoryBot.define do
  factory :user do
    trait :requestor do
    email   { "testrequestor#{Faker::Name.first_name_neutral}@m.co" } #{ "testfactorybotuser@m.co" }
    first_name { Faker::Name.first_name } 
    last_name { Faker::Name.last_name } 
    preferred_name { Faker::Name.first_name_neutral }
    address { Faker::Address.street_address }
    avatar { Faker::Avatar.image }
    default_lat { rand(-24.1000000..-23.4000000) }
    default_lng { rand(-47.8000000..-46.4000000) }
    last_loggedin {  Time.now }
    last_active { Time.now+3600 }
    password { "rrrrrr" } 
    password_confirmation { "rrrrrr" }
    end

    trait :volunteer do
    email   { "testvolunteer#{Faker::Name.first_name_neutral}@m.co" } #{ "testfactorybotuser@m.co" }
    first_name { Faker::Name.first_name } 
    last_name { Faker::Name.last_name } 
    preferred_name { Faker::Name.first_name_neutral }
    address { Faker::Address.street_address }
    avatar { Faker::Avatar.image }
    default_lat { rand(-24.1000000..-23.4000000) }
    default_lng { rand(-47.8000000..-46.4000000) }
    last_loggedin {  Time.now+3600 }
    last_active { Time.now+7200 }
    password { "vvvvvv" } 
    password_confirmation { "vvvvvv" }
    end
  end
end


  #  email   { "test#{Faker::Name.first_name_neutral}@m.co" } #{ "testfactorybotuser@m.co" }
  #  first_name { Faker::Name.first_name } 
  #  last_name { Faker::Name.last_name } 
  #  preferred_name { Faker::Name.first_name_neutral }
  #  address { Faker::Address.street_address }
  #  avatar { Faker::Avatar.image }
  #  default_lat { rand(-24.1000000..-23.4000000) }
  #  default_lng { rand(-47.8000000..-46.4000000) }
  #  last_loggedin {  Time.now }
  #  last_active { Time.now+3600 }
  #  password { "zzzzzz" } 
  #  password_confirmation { "zzzzzz" }
  # end

  # factory :signed_in_user do
  #  email   { "testsignedinuser@m.co" } #{ "testfactorybotuser@m.co" }
  #  first_name { Faker::Name.first_name } 
  #  last_name { Faker::Name.last_name } 
  #  preferred_name { Faker::Name.first_name_neutral }
  #  address { Faker::Address.street_address }
  #  avatar { Faker::Avatar.image }
  #  default_lat { rand(-24.1000000..-23.4000000) }
  #  default_lng { rand(-47.8000000..-46.4000000) }
  #  last_loggedin {  Time.now }
  #  last_active { Time.now+3600 }
  #  password { "zzzzzz" } 
  #  password_confirmation { "zzzzzz" }
  # end
 
    # email { "sometestuser@m.co" }
  #  first_name { "Testfirstname" }
  #  last_name { "Testlastname  " }
  #  preferred_name { "Testpreferredname" }
  #  gov_id { "http://govid.me" }
  #  avatar { "avatar" }
  #  address { "testaddress" }
  #   default_lat { -23.0 }
  #   default_lng { -46.0 }
  #   last_loggedin { Time.current }
  #   last_active { Time.current + 3600 }
  #   password { "zzzzzz" }
  #   password_confirmation { "zzzzzz" }
  
  #   factory :client do

  # email { "sometestuser@m.co" }
  #  first_name { "Testfirstname" }
  #  last_name { "Testlastname  " }
  #  preferred_name { "Testpreferredname" }
  #  gov_id { "http://govid.me" }
  #  avatar { "avatar" }
  #  address { "testaddress" }
  #   default_lat { -23.0 }
  #   default_lng { -46.0 }
  #   last_loggedin { Time.current }
  #   last_active { Time.current + 3600 }
  #   password { "zzzzzz" }
  #   password_confirmation { "zzzzzz" }
  #  end

   ########################

  # # create token
  # token = DeviseTokenAuth::TokenFactory.create

  # # store client + token in user's token hash
  # @current_user.tokens[token.client] = {
  #   token:  token.token_hash,
  #   expiry: token.expiry
  # }

  # # Now we have to pretend like an API user has already logged in.
  # # (When the user actually logs in, the server will send the user
  # # - assuming that the user has  correctly and successfully logged in
  # # - four auth headers. We are to then use these headers to access
  # # things which are typically restricted
  # # The following assumes that the user has received those headers
  # # and that they are then using those headers to make a request

  # new_auth_header = @current_user.build_auth_header(token.token, token.client)

  # puts 'This is the new auth header'
  # puts new_auth_header.to_s

  # # update response with the header that will be required by the next request
  # puts response.headers.merge!(new_auth_header).to_s


