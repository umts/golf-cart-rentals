Rails.application.routes.draw do
  root 'application#root'

  resources :financial_transactions

  resources :home, only: [:index]

  get 'rentals/processing', to: 'rentals#processing', as: 'rentals_processing'
  get 'rentals/cost', to: 'rentals#cost', as: 'rentals_cost'
  get 'rentals/:id/transform', to: 'rentals#transform', as: 'rental_transform'
  get 'rentals/:id/invoice', to: 'rentals#invoice', as: 'rental_invoice'
  get 'rentals/safety_pdf'
  get 'rentals/training_pdf'
  get 'help', to: 'help#show'

  resources :rentals

  resources :departments do
    post :remove_user, on: :member
  end

  resources :groups do
    member do
      post :update_permission
      post :remove_permission
      post :enable_permission
      post :remove_user
      post :enable_user
    end
  end
  resources :users do
    post :enable, on: :member
  end
  resources :item_types, only: [:index, :show, :edit, :update] do
    collection do
      get :new_item_type, as: 'new'
      post :create_item_type, as: 'create'
      get :refresh_item_types, as: 'refresh'
    end
  end
  resources :incidental_types
  resources :incurred_incidentals
  resources :damages
  resources :documents, only: [:show]
  resources :holds do
    post :lift, on: :member
  end
  resources :financial_transaction, except: %i(destroy update)
  resources :items, except: [:new, :create] do
    collection do
      get :new_item, as: 'new'
      post :create_item, as: 'create'
      get :refresh_items, as: 'refresh'
    end
  end
  get 'payment_tracking', to: 'payment_tracking#index'
  post 'payment_tracking/send_many_invoices', to: 'payment_tracking#send_many_invoices',
    as: 'payment_tracking_send_many_invoices'
  post 'payment_tracking/:rental_id/sendinvoice', to: 'payment_tracking#send_invoice',
    as: 'payment_tracking_send_invoice'

  get 'file_not_found' => 'application#render_404', as: 'file_not_found'
  match '/:anything', to: 'application#render_404', constraints: { anything: /.*/ }, via: [:get, :post]
end
