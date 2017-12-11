Rails.application.routes.draw do
  namespace :api do
    resources :questions, only: %i[index show create update destroy]

    resources :answers, only: %i[index show create update destroy]

    resources :users, only: %i[index show create update]

    resource :profile, only: %i[show]

    resources :auth_tokens, only: %i[create]
  end
end
