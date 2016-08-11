Rails.application.routes.draw do

namespace :api do
  resources :pages, only: [:index]
  post 'pages/index_page_content' => 'pages#index_page_content'
end
end
