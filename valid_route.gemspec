$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "valid_route/version"

# http://namick.tumblr.com/post/17663752365/how-to-create-a-gemified-plugin-with-rails-3-2-rspec

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "valid_route"
  s.version     = ValidRoute::VERSION
  s.authors     = ["Vince Montalbano"]
  s.email       = ["vince.montalbano@gmail.com"]
  s.homepage    = "https://github.com/vjm/valid_route"
  s.summary     = "Ensure that your routes don't conflict"
  s.description = "Ensure that your routes don't conflict"

  s.files = Dir["{lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  # s.test_files = Dir["test/**/*"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", ">= 4.0.0.beta1"
  
  s.add_development_dependency 'test-unit'
  # s.add_development_dependency 'rspec-rails'
  # s.add_development_dependency 'capybara'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency "sqlite3" #rspec wants this
end
