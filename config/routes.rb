Rails.application.routes.draw do

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'application#root'

  # Home Pages -------------------------------------------------------
  resources :home, only: [:index]

  resources :groups do
    post :update_permission, on: :member
    post :remove_permission, on: :member
    post :remove_user, on: :member
  end

  resources :users
  resources :fee_schedules
  resources :item_types

  resources :rentals do
    resources :incurred_incidentals
  end

  #Errors --------------------------------------------------------------
  get 'file_not_found' => 'application#render_404', as: 'file_not_found'
  match '/:anything', to: "application#render_404", constraints: { anything: /.*/ }, via: [:get, :post]
end
