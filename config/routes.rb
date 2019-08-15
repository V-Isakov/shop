Rails.application.routes.draw do
  root to: 'landing#index'

  resources :products, only: [:index, :show]

  get "/api/docs", to: 'landing#docs'
end
