require 'bundler'
Bundler.require

module CFoundryHelper
  autoload :Helpers, File.expand_path('../cfoundry_helper/helpers', __FILE__)
  autoload :Models, File.expand_path('../cfoundry_helper/models', __FILE__)
end