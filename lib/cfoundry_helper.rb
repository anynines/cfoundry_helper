require 'bundler'
require 'cfoundry'
require 'active_support/core_ext/object/try'

Bundler.require

module CFoundryHelper
  autoload :Helpers, File.expand_path('../cfoundry_helper/helpers', __FILE__)
  autoload :Models, File.expand_path('../cfoundry_helper/models', __FILE__)
  autoload :Errors, File.expand_path('../cfoundry_helper/errors', __FILE__)
  
  @@config = nil
  @@config_file_path = nil

  def self.env
    unless ENV['RAILS_ENV']
      return :development
    else
      ENV['RAILS_ENV'].to_sym
    end
  end
  
  def self.config
    self.read_config_file
  end
  
  def self.config_file_path=(path)
    @@config_file_path = path
  end

  def self.config_file_path
    return @@config_file_path
  end
  
  # Returns an array of target available target urls defined in the configuration file as strings.
  # @returns [Array] 
  def self.available_targets
    self.config.keys
  end
  
  # Returns the config hash for the given target url as defined in the configuration file.
  # Returns nil if the given target url is not defined within the config file.
  def self.config_for_target(url)
    self.config[url]
  end
  
  protected

  # reads the uaa and cc configuration from a config file
  def self.read_config_file
    # try to set the config file path from the env if not set already
    self.set_config_file_path_from_env if @@config_file_path.nil?

    if @@config.nil?
      self.check_config_file_path
      @@config = YAML.load_file(@@config_file_path)[CFoundryHelper.env.to_s]
    end
    @@config
  end

  def self.check_config_file_path
    raise "No configuration file path has been set! Please call ClientHelper.config_file_path= first or set a valid CFOUNDRY_HELPER_CONFIG env variable!" if @@config_file_path.nil?
    raise "There's no configuration file on #{@@config_file_path}!" if !File.exists? @@config_file_path
  end

  # sets the configuration file path from reading the CFOUNDRY_HELPER_CONFIG env variable
  def self.set_config_file_path_from_env
    config_file_path = ENV["CFOUNDRY_HELPER_CONFIG"]
    unless config_file_path.nil?
      self.config_file_path = config_file_path
    end
  end
end

CFoundryHelper.config