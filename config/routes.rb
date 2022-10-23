Rails.application.routes.draw do

  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  
  resources :profiles, only: [:edit, :update]
  resources :destinations, only: [:edit, :update]
  devise_scope :user do
    get '/users/show', to: 'users/sessions#show'
    get '/users/putting_up_list', to: 'users/sessions#putting_up_list'
    get '/users/completed_item', to: 'users/sessions#completed_item'
    get '/users/favorite_item', to: 'users/sessions#favorite_item'
    get '/users/payment_method', to: 'users/sessions#payment_method'
    get '/users/logout', to: 'users/sessions#logout'
  end

  root 'items#top'
  resources :items, only: [:new, :create, :show, :edit, :update, :destroy] do
    collection do
      get 'top'
      get 'payment_method'
      get 'thanks'
      post 'favorite', defaults: { format: 'json' }
    end
    member do
      get 'buy'
      post 'pay'
    end
  end
  resources :credit_cards, only: [:create, :new, :show, :destroy] do
    collection do
      get 'redirect_back'
    end
  end
  resources :categories, only: [:index, :show] do
    collection do
      get 'get_category_children', defaults: { format: 'json' }
      get 'get_category_grandchildren', defaults: { format: 'json' }
      get 'get_size', defaults: { format: 'json' }
    end
  end
end
