$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "valid_route/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "valid_route"
  s.version     = ValidRoute::VERSION
  s.authors     = ["Vince Montalbano"]
  s.email       = ["vince.montalbano@gmail.com"]
  s.homepage    = "https://github.com/vjm/valid_route"
  s.summary     = "Ensure that your routes don't conflict"
  s.description = "Ensure that your routes don't conflict"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", ">= 3.2.0"

  s.add_development_dependency "sqlite3"
end
