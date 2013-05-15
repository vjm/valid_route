Dummy::Application.routes.draw do
  namespace :namespaced do
    resources :whizzers
  end

  resources :others

  resources :users

  resources :pages

  root :to => 'pages#show', :id => 'home'

  match 'contact_us' => 'pages#show', :id => 'contact', :via => :get

  match 'all_users' => 'users#index', :via => :get

  match 'home' => redirect("/"), :via => :get

  resources :pages, :only => [:show], :path => "/", :as => :page_permalink, :constraints => PageConstraint.new

  resources :users, :only => [:show], :path => "/", :as => :user_profile, :constraints => UserConstraint.new

  resources :others, :only => [:show], :path => "/", :as => :other_permalink

end
