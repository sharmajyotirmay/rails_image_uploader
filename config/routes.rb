# config/routes.rb
Rails.application.routes.draw do
  namespace :api do
    resources :images, only: [:index, :create]
  end
end
