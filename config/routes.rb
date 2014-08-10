Rails.application.routes.draw do
  root to: "members#index"
  resources :members do
    collection {get "search"}
  end
  resources :members, only: [:index]
end
