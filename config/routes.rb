require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web, :at => '/sidekiq'

  post :upload, controller: 'import'

  root 'welcome#index'
end
