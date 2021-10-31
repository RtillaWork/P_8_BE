Rails.application.routes.draw do
  # namespace :api do
  #   scope :v1 do
      mount_devise_token_auth_for 'User', at: 'authn'
      
      get 'tasks/user', to: 'tasks#user'
      # get 'tasks/users', to: 'tasks#users'
      get 'tasks/dump', to: 'tasks#dump'
      get 'tasks/changes', to: 'tasks#changes'
      get 'tasks/stats', to: 'tasks#stats'
      # get 'tasks/:id/conversation', to: 'tasks#conversation'
      resources :tasks
      get 'conversations/user', to: 'conversations#user'
      get 'conversations/dump', to: 'conversations#dump'
      get 'conversations/changes', to: 'conversations#changes'
      get 'conversations/stats', to: 'conversations#stats'
      resources :conversations
      resources :messages
      post '/rails/active_storage/direct_uploads', to: 'direct_uploads#create'
  #   end
  # end
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end


# TODO

# Started GET "/tasks/1255/conversation" for 127.0.0.1 at 2021-06-26 13:20:10 -0600
  
# ActionController::RoutingError (No route matches [GET] "/tasks/1255/conversation"):
