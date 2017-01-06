Rails.application.routes.draw do
  resources :financial_transactions
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'application#root'

  # Home Pages -------------------------------------------------------
  resources :home, only: [:index]

  get 'rentals/processing', to: 'rentals#processing', as: 'rentals_processing'
  get 'rentals/cost', to: 'rentals#cost', as: 'rentals_cost'
  get 'rentals/search_users', to: 'rentals#search_users', as: 'rentals_search_users'
  get 'rentals/:id/transform', to: 'rentals#transform', as: 'rental_transform'
  get 'rentals/:id/invoice', to: 'rentals#invoice', as: 'rental_invoice'
  resources :rentals

  resources :departments do
    post :remove_user, on: :member
  end

  resources :groups do
    post :update_permission, on: :member
    post :remove_permission, on: :member
    post :enable_permission, on: :member
    post :remove_user, on: :member
    post :enable_user, on: :member
  end

  resources :users do
    post :enable, on: :member
  end
  resources :item_types, only: [:index, :show, :edit, :update]
  resources :digital_signatures, only: [:show, :index]
  resources :incidental_types
  resources :incurred_incidentals
  resources :damages
  resources :reservations
  resources :holds do
    post :lift, on: :member
  end
  resources :financial_transaction, except: %i(destroy update)
  resources :items do
    collection do
      get :new_item
      post :create_item
      get :refresh_items
    end
  end

  #Errors --------------------------------------------------------------
  get 'file_not_found' => 'application#render_404', as: 'file_not_found'
  match '/:anything', to: 'application#render_404', constraints: { anything: /.*/ }, via: [:get, :post]
end
