

if ["test", "development"].include?(ENV["RAILS_ENV"])
  require "pry"

  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)

  task :default => :spec
else
  task :default => :console
end


desc 'starts a interactive shell'
task :console do
  if ENV["RAILS_ENV"] == "production"
    exec('irb -r ./lib/cfoundry_helper.rb')
  else
    exec('pry -r ./lib/cfoundry_helper.rb')
  end
end

task c: :console