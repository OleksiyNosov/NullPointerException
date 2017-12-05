Rails.application.routes.draw do
  namespace :api do
    resources :questions, only: %i[index show create update destroy]

    resources :answers, only: %i[index show create update destroy]

    resources :users, only: %i[index show create show update]

    resource :profile, only: %i[show]

    resources :sessions, only: %i[index show create destroy]
  end
end
