Rails.application.routes.draw do
  devise_for :users
  resources :users, only: [:show, :index]
  resources :test_suites, path: :tests do
    post 'create_and_run', on: :member
    post 'archive', on: :member
    resources :test_runs, path: :runs, only: [:create, :show, :index] do
      resources :test_run_details, path: :details, only: [:show]
    end
  end
  resources :test_runs, only: [:show]

  resources :inputs do
    post 'archive', on: :member
    post 'unarchive', on: :member
    get :archived, on: :collection
  end

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
    resources :prompt_drafts, as: :draft, path: :draft
  end
  resources :accounts
  resources :organizations

  mount GoodJob::Engine => 'jobs'
  # Defines the root path route ("/")
  root "test_suites#index"
end
