Rails.application.routes.draw do
  get 'checkout/confirm'

  get 'signup' => "users#new"
  get 'login' => "users#login_form"
  post 'login' => "users#login"
  post 'logout' => "users#logout"
  get 'signup_designer' => "users#new_designer"
  patch 'users/:id/register_designer' => "users#register_designer"

  post 'users/create' => "users#create"
  get 'users/:id' => "users#show"
  get 'users/:id/edit' => "users#edit"
  patch 'users/:id/update' => "users#update"
  patch "users/:id/update_designer" => "users#update_designer"
  get 'users/:id/likes' => "users#likes"

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

  get "/checkout/confirm" => "checkout#confirm"
  post "checkout/pay" => "checkout#pay"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
