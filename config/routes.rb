Rails.application.routes.draw do
  namespace :api do
    resources :questions, only: %i[index show create update destroy]

    resources :answers, only: %i[index create update destroy]

    resources :users, only: %i[show create update]

    resource :profile, only: :show

    resources :auth_tokens, only: :create

    resources :registration_confirmations, only: :show
  end
end
