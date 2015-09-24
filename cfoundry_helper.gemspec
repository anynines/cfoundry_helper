# -*- encoding: utf-8 -*-
# stub: cfoundry_helper 0.2.1 ruby lib

Gem::Specification.new do |s|
  s.name = "cfoundry_helper"
  s.version = "0.2.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Julian Weber"]
  s.date = "2015-06-18"
  s.description = "This gem provides additional helper classes and scripts for the cfoundry gem."
  s.email = ["jweber@anynines.com"]
  s.executables = ["add_users_to_org", "create_space_for_org", "delete_orgs_and_users"]
  s.files = [".gitignore", ".gitmodules", "CHANGELOG.textile", "Gemfile", "Gemfile.lock", "README.textile", "Rakefile", "VERSION", "bin/add_users_to_org", "bin/create_space_for_org", "bin/delete_orgs_and_users", "cfoundry_helper.gemspec", "config/services.yml.example", "lib/cfoundry_helper.rb", "lib/cfoundry_helper/helpers.rb", "lib/cfoundry_helper/helpers/client_helper.rb", "lib/cfoundry_helper/helpers/organization_helper.rb", "lib/cfoundry_helper/helpers/space_helper.rb", "lib/cfoundry_helper/helpers/user_helper.rb", "lib/cfoundry_helper/models.rb", "lib/cfoundry_helper/models/organization_role.rb", "lib/cfoundry_helper/models/space_role.rb", "lib/cfoundry_helper/version.rb", "spec/integration_test.rb", "spec/spec_helper.rb", "vendor/integration-test-support"]
  s.homepage = "http://www.anynines.com"
  s.licenses = ["MIT"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.3")
  s.rubygems_version = "2.4.8"
  s.summary = "This gem provides additional helper classes and scripts for the cfoundry gem."
  s.test_files = ["spec/integration_test.rb", "spec/spec_helper.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>, ["~> 1.3"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<nats>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<cf-uaa-lib>, [">= 0"])
      s.add_development_dependency(%q<httpclient>, [">= 0"])
      s.add_development_dependency(%q<yajl-ruby>, [">= 0"])
      s.add_development_dependency(%q<pry>, [">= 0"])
      s.add_development_dependency(%q<pry-debugger>, [">= 0"])
      s.add_runtime_dependency(%q<cfoundry>, [">= 0"])
      s.add_runtime_dependency(%q<activesupport>, [">= 0"])
    else
      s.add_dependency(%q<bundler>, ["~> 1.3"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<nats>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<cf-uaa-lib>, [">= 0"])
      s.add_dependency(%q<activesupport>, [">= 0"])
      s.add_dependency(%q<httpclient>, [">= 0"])
      s.add_dependency(%q<yajl-ruby>, [">= 0"])
      s.add_dependency(%q<pry>, [">= 0"])
      s.add_dependency(%q<pry-debugger>, [">= 0"])
      s.add_dependency(%q<cfoundry>, [">= 0"])
    end
  else
    s.add_dependency(%q<bundler>, ["~> 1.3"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<nats>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<cf-uaa-lib>, [">= 0"])
    s.add_dependency(%q<activesupport>, [">= 0"])
    s.add_dependency(%q<httpclient>, [">= 0"])
    s.add_dependency(%q<yajl-ruby>, [">= 0"])
    s.add_dependency(%q<pry>, [">= 0"])
    s.add_dependency(%q<pry-debugger>, [">= 0"])
    s.add_dependency(%q<cfoundry>, [">= 0"])
  end
end
