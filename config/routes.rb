Rails.application.routes.draw do
  namespace :api do
    resources :questions, only: %i[index show create update destroy]

    resources :answers, only: %i[index create update destroy]

    resources :users, only: %i[show create update] do
      collection do
        get :confirmation
      end
    end

    resource :profile, only: :show

    resources :auth_tokens, only: :create
  end
end
