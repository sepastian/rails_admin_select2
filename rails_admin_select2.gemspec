$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rails_admin_select2/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rails_admin_select2"
  s.version     = RailsAdminSelect2::VERSION
  s.authors     = ["Sebastian Gassner"]
  s.email       = ["sebastian.gassner@gmail.com"]
  s.homepage    = "https://github.com/dieunb/rails_admin_select2"
  s.summary     = "Select2 for rails_admin"
  s.description = "A custom field providing select2 support for rails_admin."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_runtime_dependency 'rails_admin'
  s.add_runtime_dependency 'select2-rails'
end
