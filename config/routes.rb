Rails.application.routes.draw do
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  resources :patients, only: %w[index show new create edit update] do
    member do
      post 'discharge_patient', to: 'patients#discharge_patient', as: 'discharge'
    end
  end

  resources :rooms, only: %w[index show new create update] do
    member do
      get 'add_patients', to: 'rooms#add_patients', as: 'add_patients_to'
    end
  end
end
