Rails.application.routes.draw do

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'application#root'

  # Home Pages -------------------------------------------------------
  resources :home, only: [:index]

  get 'rentals/processing', to: 'rentals#processing', as: 'rentals_processing'
  get 'rentals/:id/transform', to: 'rentals#transform', as: 'rental_transform'
  get 'rentals/:id/transaction_detail', to: 'rentals#transaction_detail', as: 'rental_transaction_detail'
  resources :rentals

  resources :departments do
    post :remove_user, on: :member
  end

  resources :groups do
    post :update_permission, on: :member
    post :remove_permission, on: :member
    post :remove_user, on: :member
  end

  resources :users
  resources :item_types, only: [:index, :show, :edit, :update]
  resources :digital_signatures, only: [:show, :index]
  resources :items do
    collection do
      get :new_item
      post :create_item
      get :refresh_items
    end
  end

  resources :incidental_types
  resources :incurred_incidentals
  resources :reservations

  resources :rentals do
    resources :incurred_incidentals
  end

  #Errors --------------------------------------------------------------
  get 'file_not_found' => 'application#render_404', as: 'file_not_found'
  match '/:anything', to: 'application#render_404', constraints: { anything: /.*/ }, via: [:get, :post]
end
