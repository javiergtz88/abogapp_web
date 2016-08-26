Rails.application.routes.draw do
  get 'home/index'
  root to: 'home#index'
  get '/home'    => 'home#index'

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  devise_for :admins

  # Admin Controller
  get 'admin/portal' => 'admins#admin_portal'

  # Mensajes Controller
  get 'admin/mensajes' => 'messages#index', :as => 'mensajes'
  get 'admin/mensajes/all' => 'messages#index2', :as => 'mensajes_all'
  get 'admin/mensajes/:usuario_id' => 'messages#show', :as => 'mensajes_show'
  post 'admin/mensajes/:usuario_id/create' => 'messages#create', :as => 'new_mensaje'
  delete 'admin/mensajes/delete/:id' => 'messages#destroy', as: 'delete_mensaje'
  post 'admin/mensajes/read/:id' => 'messages#read', as: 'read_message'

  # Payment controller
  get 'do_payment' => 'payment#payment'
  get 'payments' => 'payment#index'
  get 'payment/:payment_id' => 'payment#show', :as => 'payment_show'

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      devise_scope :user do
        # API::V1::Registration Controller
        post 'registrations' => 'registrations#create', :as => 'register'

        # API::V1::SessionsController
        post 'sessions' => 'sessions#create', :as => 'login'
        delete 'sessions' => 'sessions#destroy', :as => 'logout'
      end

      # API::V1::UserController
      get 'users/:id' => 'user#show'
      post 'users/:id' => 'user#update'
      post 'users/android/fb_create' => 'user#android_fb_create'

      # API::V1::ChatController
      get 'messages/'       => 'chat#index'
      post 'messages/create' => 'chat#post_msg'
      get 'messages/last20' => 'chat#get_msgs'

      # Api::V1::MembershipsController
      get 'memberships/' => 'memberships#index'
      post 'memberships/upgrade' => 'memberships#upgrade'

      # Api::V1::WalletsController
      get 'wallets/' => 'wallets#index'
      post 'wallets/buy_credits' => 'wallets#buy_credits'

      # Api::V1::ContentController
      get 'contents/'        => 'content#index'
      post 'contents/search'  => 'content#search'
      get 'contents/article' => 'content#article'
    end
  end
end
