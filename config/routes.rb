Rails.application.routes.draw do
  devise_for :users
  resources :posts, only: [:index, :show, :create] do
    post :user_like, on: :member
    delete :user_un_like, on: :member
  end

  root to: "posts#index"
end
