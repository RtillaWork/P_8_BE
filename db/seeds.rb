# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

#  note: for 1 user, userIds sub sample of 1 to 50, taskIds subsamle of 1 to 200, 0-3 chats max per user, 0-5 tasks max per user,
include Project8Constants

NUMBER_OF_USERS = 200
# User.create!(email: "admin@tyrell.la", 
#               first_name: "Tyrell", 
#               last_name: "Lleryt", 
#               preferred_name:  "Deckard",
#               address: "100 Escape from LA Rd.",
#               avatar: Faker::Avatar.image,
#               password: "PASSWORD", password_confirmation: "PASSWORD")

# Why not Sao Paolo? ^__^
base_lat = -23.550520
base_lng = -46.633309

for i in 1..NUMBER_OF_USERS
  email = "s#{i}@m.co"
  first_name = Faker::Name.first_name
  last_name = Faker::Name.last_name
  preferred_name = if (rand(0..100) < 30) then
                     Faker::Name.first_name_neutral
                   else
                     first_name
                   end
  address = Faker::Address.street_address
  avatar = Faker::Avatar.image
  default_lat = rand(-24.1000000..-23.4000000) #rand(-24.8000000..-23.2000000) #base_lat + rand(-requestor.id..requestor.id)/1_000 + rand(-10_000..10_000)/100_000
  default_lng = rand(-47.8000000..-46.4000000)
  last_loggedin = Time.now
  # last_active = 
  password = "zzzzzz"
  password_confirmation = "zzzzzz"

  User.create!(email: email,
               first_name: first_name,
               last_name: last_name,
               preferred_name: preferred_name,
               address: address,
               avatar: avatar,
               default_lat: default_lat,
               default_lng: default_lng,
               last_loggedin: last_loggedin,
               last_active: Time.now,
               password: password, password_confirmation: password_confirmation)

  p User.all.count
end

# Create tasks for and by the_current_user, the requestor role
MAX_TASKS_PER_REQUESTOR = 30
users_all = User.all.shuffle
# users_all = User.all
users_all.each do |requestor|
  if (requestor.id.nil?) then
    next
  end
  requestor.update(last_loggedin: Time.now)
  tasks_for_requestor = rand(0..MAX_TASKS_PER_REQUESTOR)
  for i in 1..tasks_for_requestor
    kind = if (rand(1..100).odd?) then
             ONE_TIME_TASK
           else
             MATERIAL_NEED
           end
    is_fullfilled = if (rand(0..100).odd?) then
                      true
                    else
                      false
                    end
    # if (is_published && (i+rand(2) < max_number_of_tasks_per_user)) then false else !is_published end
    is_published = if is_fullfilled then
                     false
                   else
                     true
                   end
    # if (i+rand(3) < max_number_of_tasks_per_user ) then true else false end

    title = "Title by requestor #{requestor.preferred_name} #{requestor.id}: Can you please help with #{kind}"
    description = "Description: #{Faker::Lorem.paragraphs.join}"
    lat = requestor.default_lat + rand(-0.01..0.01) #rand(-1.000001..1.000001)/100 
    #rand(-24.800000..-23.200000) #base_lat + rand(-requestor.id..requestor.id)/1_000 + rand(-10_000..10_000)/100_000
    lng = requestor.default_lng + rand(-0.01..0.01) #rand(-1.000001..1.000001)/100 
    #rand(-47.900000..-46.200000) #base_lng + rand(-requestor.id..requestor.id)/1_000 + rand(-10_000..10_000)/100_000

    # puts requestor
    puts tasks_for_requestor
    puts kind
    # puts title
    # puts description
    puts lat
    puts lng

    requestor.tasks.create!({ title: title, description: description, kind: kind, unpublished_at: !is_published ? Time.current : nil,
                              is_published: is_published, is_fullfilled: is_fullfilled, lat: lat, lng: lng })
    requestor.update(last_active: Time.now)
  end
  p Task.all.count
end

# # the_current_user initates a conversation around a selected task as a  volunteer
# MAX_CONVERSATIONS_PER_VOLUNTEER = 20
# 5.times do
#   volunteers_all = User.all.shuffle
#   volunteers_all.each do |volunteer|

#     tasks_selected = Task.all.shuffle.take(rand(0..MAX_CONVERSATIONS_PER_VOLUNTEER))
#     tasks_selected.each do |task|
#       requestor = task.user #User.find(task.user_id)
#       conversations_by_volunteer = volunteer.conversation_ids
#       conversations_for_task = task.conversation_ids
#       conversation = Conversation.find_by(user_id: volunteer.id, task_id: task.id)

#       # skip this task if: 
#       # created by the current user aka volunteer, or, 
#       # if there is a conversation and it is not active, or, 
#       # if there is an active conversation and the users count is > 5  
#       # aka skip if task.user_id == the_current_user.id ||
#       # task.conversation.is_active == false ||
#       # task.conversation.users > 5

#       if (volunteer == requestor ) || (!conversation.nil? && !conversation.is_active) || (!conversation.nil? && conversation.is_active && conversations_for_task.count > 5)
#       then 
#         task.is_published = false  # touch that task and hide it
#         task.is_fullfilled = true
#         task.save
#         next
#       elsif (volunteer != requestor ) || (!conversation.nil? && conversation.is_active && conversations_for_task.count <= 5)  
#       then
#       task.is_published = false  # touch that task and hide it
#         task.is_fullfilled = false
#         task.save
#         next

#       elsif (volunteer.id.odd?) # Simulate that not all convo are active, odd volunteers won't go ahead
#         volunteer.conversations.create!({task_id: task.id, is_active: false})
#       else  # Initiate a new conversation by the even volunteer about task, not all volunteers initate a convo
#         volunteer.conversations.create!({task_id: task.id, is_active: true})
#       end
#       volunteer.update(last_active: Time.now)
#       p Conversation.all.count
#     end
#   end
# end

# # Generate messages
# MAX_MESSAGES_PER_CONVERSATIONS = 8
# MAX_VOLUNTEERS_PER_TASK = 5 # As per project specifications

# volunteers_all = User.all.shuffle
# volunteers_all.each do |volunteer|
#   volunteer_conversations = volunteer.conversations.shuffle
#   volunteer_conversations.each do |conversation|
#     requestor = conversation.task.user
#  count_of_messages = rand(0..MAX_MESSAGES_PER_CONVERSATIONS)
#     for i in 0.. count_of_messages
#   # volunteer supposedly has more messages than requestor...
#   if rand(1..10) > 3 then 
#     speaker = volunteer
#     interlocutor = requestor 
#   else 
#     speaker = requestor
#     interlocutor =  volunteer 
#   end
#   text = 
#   "#{speaker.preferred_name} says: Text by user id #{speaker.id} to #{interlocutor.preferred_name} id #{interlocutor.id} about Task id #{conversation.task_id} in conversation #{conversation.id}. This is message #{i}of#{count_of_messages}"
#   p text 
#   Message.create!(user_id: speaker.id, conversation_id: conversation.id, text: text)
# end
# p Message.all.count
# end   
# end 

# the_current_user initated conversations around selected tasks as a  volunteer
# generate messages about the conversation

# Task.all.shuffle.each do |task|
#   max_conversations_per_task = rand(0..6)
#   users_replied_to_task = User.all.shuffle.take(max_conversations_per_task)
#   users_replied_to_task.each do |user|

#   end

#   User.
#     kind = if (rand(i*10..max_number_of_tasks_per_user*10+1).odd? ) then 'one_time_task' else 'material_need' end 
#     is_published =  if (i+rand(3) < max_number_of_tasks_per_user ) then true else false end 
#     is_fullfilled = if (is_published && (i+rand(2) < max_number_of_tasks_per_user)) then false else !is_published end 
#     title = "Title#{user.id}: Can you please help with #{kind}"
#     description = "Description#{user.id}: #{Faker::Lorem.paragraphs.join}"
#     lat = base_lat + rand(-user.id..user.id)/(NUMBER_OF_USERS*100) + rand(-10_000..10_000)/100_000
#     lng = base_lng + rand(-user.id..user.id)/(NUMBER_OF_USERS*100) + rand(-10_000..10_000)/100_000
#     user.tasks.create(
#       { title: title, 
#         description: description, 
#         kind: kind, 
#         is_published: is_published, 
#         is_fullfilled: is_fullfilled, 
#         lat: lat, lng: lng})

#   end
# end


