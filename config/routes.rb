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

  get 'posts/index'=> "posts#index"
  get 'posts/new' => "posts#new"
  post 'posts/create' => "posts#create"
  post "posts/:id/comment" => "posts#comment"

  post "comments/:id/destroy" => "comments#destroy"

  get 'posts/:id' => "posts#show"
  get 'posts/:id/edit' => "posts#edit"
  patch 'posts/:id/update' => "posts#update"
  post 'posts/:id/destroy' => "posts#destroy"

  post '/likes/:post_id/create' => "likes#create"
  post '/likes/:post_id/destroy' => "likes#destroy"

  get '/' => "home#top"
  get "about" => "home#about"
  get "terms" => "home#terms"
  get "privacy" => "home#privacy"

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
