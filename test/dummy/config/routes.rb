Dummy::Application.routes.draw do
  resources :users

  resources :pages

  root :to => 'pages#show', :id => 'home'

  match 'contact_us' => 'pages#show', :id => 'contact', :via => :get

  match 'home' => redirect("/"), :via => :get

  resources :pages, :only => [:show], :path => "/", :as => :page_permalink, :constraints => PageConstraint.new

  resources :users, :only => [:show], :path => "/", :as => :user_profile

end
