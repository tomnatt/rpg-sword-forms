Rails.application.routes.draw do
  resources :sword_forms

  root 'sword_forms#index'
end
