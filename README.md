#Valid Route

## Purpose

valid_route ensures that your routes that are dynamically generated do not conflict.

## Requirements

* rails >= 4.0.0.beta1
* valid_route expects that your model's records can be found by passing the results of Model.to_param into Model.find() and Model.exists?()
    * You can implement the methods yourself (see below) or use a gem such as friendly_id to accomplish this for you.

## Usage

Let's assume you want valid a Page model with a :permalink property that dynamically determines what URL the page is accessible at.

#### Gemfile:

    gem 'valid_route'

#### page.rb:

    class Page < ActiveRecord::Base
        # rails g scaffold Page name:string permalink:string content:text

        validates :permalink, :route => true

        # The code below is not necessary if you're using a gem such as friendly_id to accomplish this for you.
        validates_format_of :permalink, :without => /^\d/, :multiline => true
        
        def self.find(input)
            input.to_i == 0 ? find_by_permalink(input) : super(input)
        end

        def self.exists?(input)
            input.to_i == 0 ? super(permalink: input) : super(input)
        end

        def to_param  # overridden
            self.permalink
        end
    end

That's it! Your routes are now protected against conflicts for all dynamic routes. Let's look at an example:

#### routes.rb:
    
    MyGreatApp::Application.routes.draw do
      resources :users

      resources :pages

      root :to => 'pages#show', :id => 'home'

      match 'home' => redirect("/"), :via => :get

      resources :pages, :only => [:show], :path => "/", :as => :page_permalink

    end

You'll automatically be protected from overwriting routes already defined in routes.rb:
    
    p = Page.new
    p.permalink = "about"
    p.valid? # => true

Resourceful routes taken:

    p.permalink = "pages"
    p.valid? # => false

    p.permalink = "users"
    p.valid? # => false

Other records for the Page model that have already been taken:

    Page.exists?("home") # => false
    p.permalink = "home"
    p.valid? # => true

    p.save # TODO: WHAT DOES THIS ACTUALLY RETURN?

    p = Page.new
    
    Page.exists?("home") # => true
    p.permalink = "home"
    p.valid? # => false

You can also check across multiple models:

#### app/constraints/page_constraint.rb:

    # http://robotslacker.com/2012/01/rails-3-routes-configuration-dynamic-segments-constraints-and-scope/
    class PageConstraint
        def initialize
        end

        def matches?(request)
            Page.exists?(request.path_parameters[:id])
        end
    end

#### user.rb:

    class User < ActiveRecord::Base
        # rails g scaffold User username:string password:string first_name:string

        validates :username, :route => true

        validates_format_of :username, :without => /^\d/, :multiline => true

        def self.find(input)
            input.to_i == 0 ? find_by_username(input) : super(input)
        end

        def self.exists?(input)
            input.to_i == 0 ? super(username: input) : super(input)
        end

        def to_param
            self.username
        end
    end


#### routes.rb:

    Dummy::Application.routes.draw do
      resources :users

      resources :pages

      root :to => 'pages#show', :id => 'home'

      match 'contact_us' => 'pages#show', :id => 'contact', :via => :get

      match 'home' => redirect("/"), :via => :get

      resources :pages, :only => [:show], :path => "/", :as => :page_permalink, :constraints => PageConstraint.new

      resources :users, :only => [:show], :path => "/", :as => :user_profile

    end

Let's take a look:

    p = Page.new
    
    Page.exists?("home") # => false
    p.permalink = "home"
    p.valid? # => true
    p.save

    p = Page.new
    
    Page.exists?("about") # => false
    p.permalink = "about"
    p.valid? # => true
    p.save

    u = User.new
    u.username = "coolperson"
    u.valid? # => true
    u.save

    u = User.new
    u.username = "home"
    u.valid? # => false

    u.username = "about"
    u.valid? # => false

    u.username = "pages"
    u.valid? # => false

    p = Page.new
    p.permalink = "coolperson"
    p.valid? # => false


### Reserving Additional Routes

You can also reserve additional routes to prevent them from being used in a particular model:

#### page.rb:

    class Page < ActiveRecord::Base
        # rails g scaffold Page name:string permalink:string content:text

        validates :permalink, :route => {reserved_routes: ["reserved", "fake_page"]}

        # ...
    end

    p = Page.new
    p.permalink = "fake_page"
    p.valid? # => false

### Unreserving Routes

Conversely, if you want to avoid checking certain routes for validity, you can do so as well: 

#### page.rb:

    class Page < ActiveRecord::Base
        # rails g scaffold Page name:string permalink:string content:text

        validates :permalink, :route => {reserved_routes: ["reserved", "fake_page"], unreserved_routes: ["users"]}

        # ...
    end

    p = Page.new
    p.permalink = "users"
    p.valid? # => true

# Credits

* vince.montalbano@gmail.com

# Note on Patches/Pull Requests

* Fork the project.

* Make your feature addition or bug fix.

* Add tests for it. This is important so I don't break it in a future version unintentionally.

* Commit, do not mess with rakefile, version, or history. (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)

* Send me a pull request. Bonus points for topic branches.

# Copyright

Copyright &copy; 2013 Vince Montalbano. See LICENSE for details