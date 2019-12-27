Rails.application.routes.draw do
  root 'flights#index'

  resources :flights do
    member do
      get :print
    end
    resources :pilots
    resources :waypoints, except: %i[index]
  end
end
