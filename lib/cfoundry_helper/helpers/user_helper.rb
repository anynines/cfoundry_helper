module CFoundryHelper::Helpers
  module UserHelper

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