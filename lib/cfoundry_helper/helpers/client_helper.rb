require 'yaml'

module CFoundryHelper::Helpers
  module ClientHelper
    @@config = nil
    @@scim_client = nil
    @@cloud_controller_client = nil

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
      # just return the already initialized client if present
      return @@cloud_controller_client unless @@cloud_controller_client.nil?

      self.read_config_file
      token_issuer = CF::UAA::TokenIssuer.new(@@config['uaa']['site'], "cf")
      token_info = token_issuer.implicit_grant_with_creds(@@config['cloud_controller'])
      access_token = token_info.info["access_token"]
      token = CFoundry::AuthToken.from_hash({:token => "bearer #{access_token}"})
      @@cloud_controller_client = CFoundry::V2::Client.new(@@config['cloud_controller']['site'], token)
    end

    protected

    def self.read_config_file
      if @@config.nil?
        config_file_path = File.join(File.expand_path('../../../../config', __FILE__), 'services.yml')
        @@config = YAML.load_file(config_file_path)[CFoundryHelper.env.to_s]
      end
      @@config
    end

  end
end