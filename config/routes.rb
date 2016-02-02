Rails.application.routes.draw do
  resources :users
  resources :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'application#root'

  # Home Pages -------------------------------------------------------
  resources :home, only: [:index]
end
