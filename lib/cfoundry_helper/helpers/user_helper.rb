module CFoundryHelper::Helpers
  module UserHelper

    def self.get_email_for_user(user)
      guid = user.guid

      # fetch the data from the uaa
      scim_cl = CFoundryHelper::Helpers::ClientHelper.scim_client
      query_result = scim_cl.query(:user, {:filter => "id eq '#{guid}'"})

      if query_result["resources"].nil? || query_result["resources"].empty?
        raise "No user with the guid: #{guid} could be found on the uaa!"
      end

      query_result["resources"].first["emails"].first["value"]
    end

    def self.create_user(attributes)
      raise "The given attributes hash is nil!" if attributes.nil?
      raise "No user email given!" if attributes[:email].nil?
      raise "No password attribute given!" if attributes[:password].nil?

      # no admin user is created as a default
      admin = false
      unless attributes[:admin].nil?
        admin = attributes[:admin]
      end

      user = CFoundryHelper::Helpers::ClientHelper.cloud_controller_client.register(attributes[:email], attributes[:password])

      if admin
        user.admin = true
        user.update!
      end

      user
    end

    def self.get_cc_users
      CFoundryHelper::Helpers::ClientHelper.cloud_controller_client.users
    end

    def self.get_user_emails
      scim_cl = CFoundryHelper::Helpers::ClientHelper.scim_client
      query_result = scim_cl.query(:user)

      if query_result["resources"].nil? || query_result["resources"].empty?
        raise "No user emails could be found in the uaa!"
      end

      res_array = Array.new
      user_guid = query_result["resources"].each do |r|
        res_array << r["emails"].first["value"]
        res_array.sort!
      end

      res_array
    end

    def self.email_exists?(email)
      begin
        u = self.get_user_by_email email
          return true
      rescue
        return false
      end
    end

    # returns the CFoundry::V2::User with the given email address if present
    # throws an exception if the given user is not present in the system
    def self.get_user_by_email(email)

      # fetch the data from the uaa
      scim_cl = CFoundryHelper::Helpers::ClientHelper.scim_client
      query_result = scim_cl.query(:user, {:filter => "email eq '#{email.strip}'"})

      if query_result["resources"].nil? || query_result["resources"].empty?
        raise "No user with the email address: #{email} could be found!"
      end

      user_guid = query_result["resources"].first["id"]

      # retrieve the user from the CC
      user = nil
      cc_cl = CFoundryHelper::Helpers::ClientHelper.cloud_controller_client
      cc_cl.users.each do |u|
        if u.guid.eql? user_guid
          user = u
          break
        end
      end

      if user.nil?
        raise "Could not find the user with the email address: #{email} in the Cloud Controller!"
      end
      user
    end

  end
end