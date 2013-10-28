require 'bundler'
require 'cfoundry'
require 'active_support/core_ext/object/try'
require 'active_support/hash_with_indifferent_access'

Bundler.require

module CFoundryHelper
  autoload :Helpers, File.expand_path('../cfoundry_helper/helpers', __FILE__)
  autoload :Models, File.expand_path('../cfoundry_helper/models', __FILE__)
  autoload :Errors, File.expand_path('../cfoundry_helper/errors', __FILE__)
  
  @@config = nil
  
  # Loads the configuration from the specified hash.
  def self.load_config_from_hash(hash)
    config = hash
    check_config! config
    @@config = config
    @@config
  end
  
  # Loads the configuration from the specified yaml file.
  def self.load_config_from_file(file_location)
    raise "There's no configuration file on #{file_location}!" unless File.exists? file_location
    config = YAML.load_file(file_location)
    check_config! config
    @@config = config
    @@config
  end
  
  def self.config
    @@config
  end
  
  # Returns an array of target available target urls defined in the configuration file as strings.
  # @returns [Array] 
  def self.available_targets
    self.config.keys
  end
  
  # Returns the config hash for the given target url as defined in the configuration.
  # Returns nil if the given target url is not defined within the configuration.
  def self.config_for_target(url)
    self.config[url]
  end
  
  private 
  
  def self.check_config!(config)
    raise "No target hashes are defined within the configuration!" if config.count == 0
    
    config.each do |target,hash|
      # check uaa config
      raise "No uaa section is specified within the target #{target} !" if hash["uaa"].nil?
      raise "No uaa:site is specifed within the target #{target} !" if hash["uaa"]["site"].nil?
      raise "No uaa:client_id is specifed within the target #{target} !" if hash["uaa"]["client_id"].nil?
      raise "No uaa:client_secret is specifed within the target #{target} !" if hash["uaa"]["client_secret"].nil?      
      
      # check cc config
      raise "No cloud_controller section is specified within the target #{target} !" if hash["cloud_controller"].nil?
      raise "No cloud_controller:site is specifed within the target #{target} !" if hash["cloud_controller"]["site"].nil?
      raise "No cloud_controller:username is specifed within the target #{target} !" if hash["cloud_controller"]["username"].nil?
      raise "No cloud_controller:password is specifed within the target #{target} !" if hash["cloud_controller"]["password"].nil?
    end
  end
end