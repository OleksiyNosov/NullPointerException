Rails.application.routes.draw do
  namespace :api do
    resources :questions

    resources :answers
  end
end
