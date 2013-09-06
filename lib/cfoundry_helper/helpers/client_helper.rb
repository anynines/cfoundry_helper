require 'yaml'

module CFoundryHelper::Helpers
  module ClientHelper
    @@config = nil
    @@scim_client = nil
    @@cloud_controller_client = nil
    @@config_file_path = nil
    @@auth_token = nil

    def self.set_config_file_path(path)
      @@config_file_path = path
    end

    def self.config_file_path
      return @@config_file_path
    end

    def self.get_cc_target_url
      return self.cloud_controller_client.target
    end

    def self.get_auth_token
      self.cloud_controller_client if @@auth_token.nil?
      return @@auth_token
    end

    ##
    # Use this client to connect to the uaa-service and
    # check wether a user alredy exists.
    #
    # scim is a "System for Cross-domain Identity Management" and
    # it is uesd by the uaa service.
    # see http://www.simplecloud.info/
    def self.scim_client
      # just return the already initialized client if present
      return @@scim_client unless @@scim_client.nil?

      self.read_config_file
      token_issuer = CF::UAA::TokenIssuer.new(
          @@config['uaa']['site'],
          @@config['uaa']['client_id'],
          @@config['uaa']['client_secret'])

      token_info = token_issuer.client_credentials_grant
      access_token = token_info.info["access_token"]
      @@scim_client = CF::UAA::Scim.new(@@config['uaa']['site'], "bEareR #{access_token}")
    end

    ##
    # Use this client to connect to the cloudcontroller
    # and register a new user.
    def self.cloud_controller_client
      # just return the already initialized client if it was explicit setted.
      # Don't cache the client in this method because long running apps will
      # have some trouble with expired auth tokens.
      # TODO: Refresh the token with the uaa refresh method.
      return @@cloud_controller_client if @@cloud_controller_client

      self.read_config_file
      token_issuer = CF::UAA::TokenIssuer.new(@@config['uaa']['site'], "cf")
      token_info = token_issuer.implicit_grant_with_creds(@@config['cloud_controller'])
      access_token = token_info.info["access_token"]
      token = CFoundry::AuthToken.from_hash({:token => "bearer #{access_token}"})
      @@auth_token = token
      CFoundry::V2::Client.new(@@config['cloud_controller']['site'], token)
    end


    def self.set_scim_client(client)
      @@scim_client = client
    end

    def self.set_cc_client(client)
      @@cloud_controller_client = client
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
      raise "No configuration file path has been set! Please call ClientHelper.set_config_file_path first or set a valid CFOUNDRY_HELPER_CONFIG env variable!" if @@config_file_path.nil?
      raise "There's no configuration file on #{@@config_file_path}!" if !File.exists? @@config_file_path
    end

    # sets the configuration file path from reading the CFOUNDRY_HELPER_CONFIG env variable
    def self.set_config_file_path_from_env
      config_file_path = ENV["CFOUNDRY_HELPER_CONFIG"]
      unless config_file_path.nil?
        self.set_config_file_path config_file_path
      end
    end

  end
end