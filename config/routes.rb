Rails.application.routes.draw do
  devise_for :users
  resources :users, only: [:show, :index]

  resources :prompts do
    post 'archive', on: :member
    post 'unarchive', on: :member
    post 'create_draft', on: :member
    get :archived, on: :collection
    resources :prompt_versions, as: :versions, path: :version do
      collection do
        post 'preview'
      end
    end
    resources :prompt_drafts, as: :drafts, path: :draft
  end
  resources :accounts
  resources :organizations

  # Defines the root path route ("/")
  root "prompts#index"
end
