Rails.application.routes.draw do
  root 'flights#index'

  resources :flights do
    member do
      get :print
      get :print_images
      post :clone
    end
    resources :pilots
    resources :waypoints do
      collection do
        post :copy_from
      end
    end
  end

  get 'airbases', to: 'airbases#index'
  get 'procedures', to: 'airbases#procedures'
end
