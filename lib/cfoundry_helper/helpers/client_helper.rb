require 'yaml'

module CFoundryHelper::Helpers
  module ClientHelper
    @@scim_client = nil
    @@cloud_controller_client = nil
    @@auth_token = nil
    @@current_target_url = nil

    def self.current_target_url=(url)
      @@current_target_url = url
    end
    
    def self.current_target_url
      return @@current_target_url
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
      raise CFoundryHelper::Errors::ConfigurationError, "The ClientHelper's current target url is not defined in the configuration yaml file!" if CFoundryHelper.config[@@current_target_url].nil?
      
      return @@scim_client unless @@scim_client.nil?

      token_issuer = CF::UAA::TokenIssuer.new(
          CFoundryHelper.config[@@current_target_url]['uaa']['site'],
          CFoundryHelper.config[@@current_target_url]['uaa']['client_id'],
          CFoundryHelper.config[@@current_target_url]['uaa']['client_secret'])

      token_info = token_issuer.client_credentials_grant
      access_token = token_info.info["access_token"]
      @@scim_client = CF::UAA::Scim.new(CFoundryHelper.config[@@current_target_url]['uaa']['site'], "bEareR #{access_token}")
    end

    ##
    # Use this client to connect to the cloudcontroller
    # and register a new user.
    def self.cloud_controller_client
      # just return the already initialized client if present
      raise CFoundryHelper::Errors::ConfigurationError, "The ClientHelper's current target url is not defined in the configuration!" if CFoundryHelper.config[@@current_target_url].nil?
      
      
      # just return the already initialized client if it was explicit setted.
      # Don't cache the client in this method because long running apps will
      # have some trouble with expired auth tokens.
      # TODO: Refresh the token with the uaa refresh method.
      return @@cloud_controller_client if @@cloud_controller_client

      token_issuer = CF::UAA::TokenIssuer.new(CFoundryHelper.config[@@current_target_url]['uaa']['site'], "cf")
      token_info = token_issuer.implicit_grant_with_creds(CFoundryHelper.config[@@current_target_url]['cloud_controller'])
      access_token = token_info.info["access_token"]
      token = CFoundry::AuthToken.from_hash({:token => "bearer #{access_token}"})
      @@auth_token = token
      CFoundry::V2::Client.new(CFoundryHelper.config[@@current_target_url]['cloud_controller']['site'], token)
    end

    def self.set_scim_client(client)
      @@scim_client = client
    end

    def self.set_cc_client(client)
      @@cloud_controller_client = client
    end
  end
end