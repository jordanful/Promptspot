Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',

  }

  resources :test_suites, path: :tests do
    post 'create_and_run', on: :member
    post 'archive', on: :member
    post 'clone', on: :member
    resources :test_runs, path: :runs, only: %i[create show index destroy] do
      post 'archive', on: :member
      post 'unarchive', on: :member
      get 'download', on: :member, defaults: { format: :csv }, constraints: { format: :csv }
      resources :test_run_details, path: :details, only: [:show]
    end
  end

  resources :inputs

  resources :prompts do
    post 'archive', on: :member
    post 'unarchive', on: :member
    post 'create_draft', on: :member
    get :archived, on: :collection
    resources :prompt_versions, as: :versions, path: :version, only: [:show] do
      collection do
        post 'preview'
      end
    end
    resources :prompt_drafts, as: :draft, path: :draft
  end
  resources :invites, only: [:create] do
    member do
      get :accept
      post :create_user_from_invite
    end
  end

  resources :accounts, only: %i[show]
  resources :organizations, only: %i[update]
  namespace :api do
    namespace :v1 do
      get 'docs', to: 'docs#index'
      resources :prompts, only: %i[index show], constraints: { format: :json }
    end
  end

  mount GoodJob::Engine => 'jobs'
  root "test_suites#index"
end
