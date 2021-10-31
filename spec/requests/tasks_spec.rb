 require 'rails_helper'
 include P8beror6v01

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe "/tasks", type: :request do
  
  # Task. As you add validations to Task, be sure to
  # adjust the attributes here as well.
  before(:all) {
# base_lat = -23.550520
# base_lng = -46.633309

#   email = "testu@m.co"
#   first_name = Faker::Name.first_name
#   last_name = Faker::Name.last_name
#   preferred_name =  if (rand(0..100) < 30) then Faker::Name.first_name_neutral else first_name end
#   address = Faker::Address.street_address
#   avatar = Faker::Avatar.image
#   default_lat = rand(-24.1000000..-23.4000000) 
#   default_lng = rand(-47.8000000..-46.4000000)
#   last_loggedin = Time.now
#   # last_active = 
#   password = "zzzzzz"
#   password_confirmation = "zzzzzz"

      # kind = ONE_TIME_TASK
    # is_fullfilled = false
    # is_published = true
    # title = "Title by requestor Can you please help"
    # description = "Description: #{Faker::Lorem.paragraphs.join}"
    # lat = base_lat + rand(-0.01..0.01) 
    # lng = base_lng + rand(-0.01..0.01)
    # unpublished_at =  nil
  }

   let(:testuser){   User.create!(email: "test#{Faker::Name.first_name_neutral}@m.co", 
              first_name: Faker::Name.first_name, 
              last_name: Faker::Name.last_name, 
              preferred_name: Faker::Name.first_name_neutral,
              address: Faker::Address.street_address,
              avatar: Faker::Avatar.image,
              default_lat: rand(-24.1000000..-23.4000000),
              default_lng: rand(-47.8000000..-46.4000000),
              last_loggedin:  Time.now,
              last_active: Time.now+3600,
              password: "zzzzzz", password_confirmation: "zzzzzz")
   }

  # let(:user, :requestor) {
  # User.create!(email: email, 
  #             first_name: first_name, 
  #             last_name: last_name, 
  #             preferred_name: preferred_name,
  #             address: address,
  #             avatar: avatar,
  #             default_lat: default_lat,
  #             default_lng: default_lng,
  #             last_loggedin: last_loggedin,
  #             last_active: Time.now,
  #             password: password, password_confirmation: password_confirmation)
  # }
  let(:valid_attributes) {
  
#  { title: title,description: description,kind: kind, unpublished_at: !is_published ? Time.current : nil,
#       is_published: is_published,is_fullfilled: is_fullfilled,lat: lat, lng: lng}
    # { title: "Title by requestor Can you please help",description: "Description: #{Faker::Lorem.paragraphs.join}",kind: 'OTT', unpublished_at:  nil,
    #   is_published: true,is_fullfilled: false,lat:  -23.550520 + rand(-0.01..0.01), lng: -46.633309 + rand(-0.01..0.01)}
      
    # skip("Add a hash of attributes valid for your model")
    {title: 'T'*60,
      description: 'D'*200,
       kind: 'MN',
  is_published: true,
  unpublished_at: nil,
  is_fullfilled: false,
  lat: -23.4,
  lng: -46.5,
  created_at: Time.current,
  updated_at: Time.current,
    user: FactoryBot.create(:user, :requestor)
  }
}

  let(:invalid_attributes) {
    # skip("Add a hash of attributes invalid for your model")
  #    {title: 'T'*65,
  #     description: 'D'*301,
  #      kind: 'MN',
  # is_published: true,
  # unpublished_at: nil,
  # is_fullfilled: false,
  # lat: -23.4,
  # lng: -46.5,
  # created_at: Time.current,
  # updated_at: Time.current,
  #   user: FactoryBot.create(:user, :requestor)
  # }
  valid_attributes.merge!( {user: nil})
  }

  describe "GET /index" do
    it "renders a successful /task response" do
        # request.headers.merge! resource.create_new_auth_token
      task = Task.create! valid_attributes #.merge(user: testuser)
      # puts
      # puts task.inspect
      # puts
      # puts task.user.inspect
      # puts
      user_auth_token = task.user.create_new_auth_token
      # puts user_auth_token
      # puts
      # # puts headers.inspect
      # puts
      get tasks_url,  params: {}, headers: user_auth_token.merge!({ 'HTTP_ACCEPT' => "application/json" }) #, format: :json # { 'HTTP_ACCEPT' => "application/json" } #user_auth_token
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful /task/:id response" do
      task = Task.create! valid_attributes
      # task = FactoryBot.create(:task)
      user_auth_token = task.user.create_new_auth_token
      get task_url(task),  params: {}, headers: user_auth_token.merge!({ 'HTTP_ACCEPT' => "application/json" })
      expect(response).to be_successful
    end
  end

 
  describe "POST /create" do
    context "with valid parameters" do        
      it "creates a new Task" do
        task = Task.create! valid_attributes
        user_auth_token = task.user.create_new_auth_token
        
        expect {
          # post tasks_url, params: { task: valid_attributes }, headers: user_auth_token.merge!({ 'HTTP_ACCEPT' => "application/json" })
          post tasks_url, params: { task: valid_attributes }, headers: user_auth_token.merge!({ 'HTTP_ACCEPT' => "application/json" })
        }.to change(Task, :count).by(1)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        # skip("Add a hash of attributes valid for your model")
          {title: 'New T',
      description: 'D'*200,
       kind: 'MN',
  is_published: false,
  unpublished_at: Time.current,
  is_fullfilled: false,
  lat: -23.4,
  lng: -46.5,
  created_at: Time.current,
  updated_at: Time.current,
    # user: FactoryBot.create(:user, :requestor)
  }
      }

      it "updates the requested task" do
        # task = Task.create! valid_attributes
        task = Task.create! valid_attributes
        user_auth_token = task.user.create_new_auth_token
        patch task_url(task), params: { task: new_attributes }, headers: user_auth_token.merge!({ 'HTTP_ACCEPT' => "application/json" })
        task.reload
        # skip("Add assertions for updated state")
        expect(task.title).not_to eql(new_attributes[:title])
        expect(task.description).to eql(valid_attributes[:description])
        expect(task.kind).to eql(valid_attributes[:kind])
        expect(task.is_published).not_to eql(valid_attributes[:is_published])
      end
    end
  end
end
