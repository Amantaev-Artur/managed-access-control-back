Rails.application.routes.draw do
  resources :groups
  resources :accesses
  resources :users, only: %w[create index]
  put '/user', to: 'users#update'
  post '/auth', to: 'users#auth'
  get '/user_info', to: 'users#info'
  post '/groups/:group_id/users/:user_id', to: 'groups#add_user'
  delete '/groups/:group_id/users/:user_id', to: 'groups#delete_user'
end
