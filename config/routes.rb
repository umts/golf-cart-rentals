Rails.application.routes.draw do
  root 'application#root'

  resources :home, only: [:index]

  get 'rentals/processing', to: 'rentals#processing', as: 'rentals_processing'
  get 'rentals/cost', to: 'rentals#cost', as: 'rentals_cost'
  get 'rentals/:id/transform', to: 'rentals#transform', as: 'rental_transform'
  get 'rentals/:id/invoice', to: 'rentals#invoice', as: 'rental_invoice'
  get 'rentals/safety_pdf'
  get 'rentals/training_pdf'

  #---Help Forms-------------------------------------------------------------
  get 'help', to: 'help#show'
  get 'help/schedule', to: 'help#schedule' , as: 'schedule'
  get 'help/new_hold', to: 'help#new_hold' , as: 'new_hold_help'
  get 'help/new_incidental_type', to: 'help#new_incidental_type', as: 'new_incidental_type_help'
  get 'help/new_item_type', to: 'help#new_item_type' , as: 'new_item_type_help'
  get 'help/new_item', to: 'help#new_item' , as: 'new_item_help'
  get 'help/new_group', to: 'help#new_group' , as: 'new_group_help'
  get 'help/new_user', to: 'help#new_user' , as: 'new_user_help'
  get 'help/new_department', to: 'help#new_department' , as: 'new_department_help'
  #----------------------------------------------------------------------------
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
  resources :financial_transactions, only: %i(index new create)
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
