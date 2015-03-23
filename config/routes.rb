Rails.application.routes.draw do
  devise_for :users

  root to: 'home#index'

  get 'about', to: 'home#about'
  get 'profile', to: 'profile#index'
  post 'profile_update', to: 'profile#update'

  post 'generate_public_link', to: 'profile#generate_public_link'

  get 'public/:token', to: 'public#index', as: 'public'
  get 'public/locations/:token', to: 'public#locations', as: 'public_locations'

  get 'range_search', to: 'range_search#index', as: 'range_search'
  post 'range_search', to: 'range_search#search', as: 'execute_range_search'

  get 'followers', to: 'people#followers'
  get 'following', to: 'people#following'

  post 'send_follow_request', to: 'people#send_follow_request'
  post 'people/accept_request/:id', to: 'people#accept_request', as: 'accept_request'
  post 'people/deny_request/:id', to: 'people#deny_request', as: 'deny_request'

  get 'location/:id', to: 'location#for_user', as: 'location'

  namespace :api do
    post 'update/location', to: 'update#location'
  end
end
