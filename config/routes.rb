require 'sidekiq/web'

Rails.application.routes.draw do
  mount EventBrowser => '/res' if Rails.env.development?
  mount Sidekiq::Web => '/sidekiq' if Rails.env.development?

  resources :uploads, only: [:index, :create]

  resources :reviewing, only: [:index] do
    member do
      post :reject
      post :pre_approve
      post :approve
    end
  end

  resources :tagging, only: [:index, :destroy, :create]
end
