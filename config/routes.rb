Rails.application.routes.draw do
  resources :flights do
    member do
      get :print
    end
    resources :pilots
    resources :waypoints
  end
end
