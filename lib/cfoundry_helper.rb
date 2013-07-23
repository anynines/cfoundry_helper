require 'bundler'
require 'cfoundry'

Bundler.require

module CFoundryHelper
  autoload :Helpers, File.expand_path('../cfoundry_helper/helpers', __FILE__)
  autoload :Models, File.expand_path('../cfoundry_helper/models', __FILE__)

  def self.env
    unless ENV['RAILS_ENV']
      return :development
    else
      ENV['RAILS_ENV'].to_sym
    end
  end
end