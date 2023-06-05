Rails.application.routes.draw do
  devise_for :users
  resources :users, only: [:show, :index]

  resources :prompts do
    resources :prompt_versions, as: :versions, path: :version
  end
  resources :accounts
  resources :organizations

  # Defines the root path route ("/")
  root "prompts#index"
end
