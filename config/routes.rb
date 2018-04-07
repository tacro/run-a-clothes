Rails.application.routes.draw do

  root 'home#top'
  devise_for :users, :controllers => {
     :omniauth_callbacks => "omniauth_callbacks"
   }

  get 'users/:id' => "users#show"
  get 'users/:id/likes' => "users#likes"
  get 'users/:id/timeline' => "users#following_posts"
  get 'users/:id/edit' => "users#edit"
  patch 'users/:id/update' => "users#update"

  # get 'items/index'=> "posts#index"
  get 'items/new' => "posts#new"
  post 'items/create' => "posts#create"
  post "items/:id/comment" => "posts#comment"
  get 'items/hashtag/:name' => "posts#hashtags"

  post "comments/:id/destroy" => "comments#destroy"

  get 'items/:id' => "posts#show"
  get 'items/:id/edit' => "posts#edit"
  patch 'ietms/:id/update' => "posts#update"
  post 'items/:id/destroy' => "posts#destroy"

  post '/likes/:post_id/create' => "likes#create"
  post '/likes/:post_id/destroy' => "likes#destroy"

  get '/' => "home#top"
  get "about" => "home#about"
  get "terms" => "home#terms"
  get "privacy" => "home#privacy"
  get "help" => "home#help"

  resources :users do
    member do
     get :following, :followers
    end
  end
  resources :relationships,  only: [:create, :destroy]

  # get "/checkout/confirm" => "checkout#confirm"
  # post "checkout/pay" => "checkout#pay"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
