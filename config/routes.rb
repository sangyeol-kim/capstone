Rails.application.routes.draw do
  root 'homes#index'
  
  post 'homes/create' => 'homes#create'
  
  get 'homes/index'
  
  get 'users/page/:id' => 'users#page'
  
  get 'users/confirm'
  
  resources :posts do
    member do
      put "like", to:    "posts#upvote"
      put "dislike", to: "posts#downvote"
    end
  end

  resources :bulletins do
    resources :posts
  end
  
  # sign_up을 Get 방식 → Post 방식으로 변경 작업.
  devise_scope :user do
    post 'users/sign_up', to: 'users/registrations#new'
  end
  
  resources :comments, only: [:create, :destroy]
  
  devise_for :users, controllers: { registrations: 'users/registrations' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  #tinymce
  post '/tinymce_assets' => 'tinymce_assets#create'
end
