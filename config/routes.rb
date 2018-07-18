Rails.application.routes.draw do

namespace :api do
  resources :pages, only: [:index]
  post 'pages/index_page_content' => 'pages#index_page_content'
end

  resources :users, only: [:index]
  patch 'users/update_admin' => 'users#update_admin'
  patch 'users/update_admin_incorrect_0' => 'users#update_admin_incorrect_0'
  patch 'users/update_admin_incorrect_1' => 'users#update_admin_incorrect_1'
  patch 'users/update_admin_incorrect_2' => 'users#update_admin_incorrect_2'
  patch 'users/update_admin_secure' => 'users#update_admin_secure'
end
