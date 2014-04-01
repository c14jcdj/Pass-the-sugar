PassTheSugar::Application.routes.draw do
  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)

  root to: 'accounts#index'

  resources :sessions, only: [ :new, :create, :destroy ]

  get 'help', :to => 'dashboard#help'
  get 'graphs/:account_id/diabetics/:id', :to => 'graphs#show', :as => 'show_graph'
  get 'dashboard/get', :to => 'dashboard#get', :as => 'get_submenu'
  get 'diabetics/:id/dashboard', :to => 'dashboard#diabetic', :as => 'diabetic_dashboard'
  get 'dashboard', :to => 'dashboard#show', :as => 'dashboard'

  put 'accounts/changepassword', :to => 'accounts#change_password'
  resources :accounts do
    resources :diabetics, except: [ :index, :delete ]
  end

  resources :diabetics, only: [] do
    resources :records, :preferences, :doctors, except: [:delete]
  end

end
