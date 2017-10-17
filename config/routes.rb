Rails.application.routes.draw do
  namespace :api do
    resources :questions, except: %i[new edit] do
      resources :answers, except: %i[new edit]
    end
  end
end
