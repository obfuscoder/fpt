Rails.application.routes.draw do
  root 'flights#index'

  resources :flights do
    collection do
      get :defaults
    end
    member do
      get :print
      get :print_images
      post :clone
    end
    resources :pilots
    resources :waypoints, only: %i[index create destroy] do
      member do
        post :update
      end
      collection do
        put :copy_from
        get :export
      end
    end
    resource :loadout, only: %i[edit update]
  end

  get 'airbases', to: 'airbases#index'
  get 'procedures', to: 'airbases#procedures'
  get 'spins', to: 'spins#show'
end
