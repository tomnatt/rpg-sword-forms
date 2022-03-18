Rails.application.routes.draw do
  devise_for :users
  scope '/admin' do
    resources :users
  end

  root to: 'sword_forms#index'
  resources :sword_forms, :tags
end
