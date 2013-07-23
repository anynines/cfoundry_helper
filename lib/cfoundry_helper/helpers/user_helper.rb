module CFoundryHelper::Helpers
  module UserHelper

    # returns the associated email address for the given cc user
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

    # creates a user with the given email and password
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

    # deletes a user from the cc and the uaa
    # returns true if the user was deleted
    # throws an exception on errors
    def self.delete_user(user)
      self.delete_user_from_uaa user
      self.delete_user_from_cc  user
      return true
    end

    def self.delete_user_by_email(email)
      user = self.get_user_by_email email
      self.delete_user user
    end

    # returns an array of CFoundry::V2::User registered within the cloud controller
    def self.get_cc_users
      CFoundryHelper::Helpers::ClientHelper.cloud_controller_client.users
    end

    # returns an array of all user emails registered within the uaa
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

    # checks whether a user with the given email address exists
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

    # sets a new password for the given user
    # returns the user
    def self.set_user_password(user, newpass)
      scim_cl = CFoundryHelper::Helpers::ClientHelper.scim_client
      scim_cl.change_password user.guid, newpass, nil
      return user
    end



    private

    # deletes a user from the uaa
    # returns true if the user was deleted
    def self.delete_user_from_uaa(user)
      raise "The given user is nil!" if user.nil?
      user_id = user.guid

      scim_cl = CFoundryHelper::Helpers::ClientHelper.scim_client
      result = scim_cl.delete(:user, user_id)
      return true
    end

    # deletes a user from the cloud controller
    def self.delete_user_from_cc(user)
      raise "The given user is nil!" if user.nil?
      user.delete!
    end

  end
end