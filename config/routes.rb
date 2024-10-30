Rails.application.routes.draw do
  devise_for :users
  root 'dashboard#index'

  resources :loans do
    member do
      patch :approve
      patch :reject
      patch :readjust
      put   :accept
      put :repay
    end
  end

  # Dashboard
  get 'dashboard', to: 'dashboard#index'
  get 'dashboard/filter', to: 'dashboard#filter'

end
