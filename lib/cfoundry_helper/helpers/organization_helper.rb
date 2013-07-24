module CFoundryHelper::Helpers
    module OrganizationHelper

        # returns an array of all CFoundry::V2::Organizations
        def self.get_organizations
          self.cc_client.organizations
        end

        def self.exists?(org_name)
          self.cc_client.organizations.each do |o|
            return true if o.name.eql? org_name
          end
          return false
        end

        # creates an CFoundry::V2::Organization with the given attributes contained in the hash
        # returns the created organization
        # throws an exception when an error occures during creating the organization
        def self.create_organization(attributes)
          raise "The given attributes hash is nil!" if attributes.nil?
          raise "No organization name given!" if attributes[:name].nil?
          raise "No billing_enabled attribute given!" if attributes[:billing_enabled].nil?

          org = self.cc_client.organization
          org.name = attributes[:name]
          org.billing_enabled = attributes[:billing_enabled]
          org.create!
          org
        end

        # returns the organization with the given name if it exists
        # throws an exception when the given organization doesn't exist
        def self.get_organization_by_name(name)
          cc_client.organization_by_name name
        end

        # returns an array of Cfoundry::V2::Users registered within the given organization
        def self.get_users(org)
          org.users
        end

        # adds the given user to the given organization
        # returns the organization
        def self.add_user(org, user)
          org.add_user user
          org.update!
          org
        end

        # adds the user with the given email to the given organization
        # returns the organization
        def self.add_user_by_email(org, email)
          user = CFoundryHelper::Helpers::UserHelper.get_user_by_email email
          self.add_user org, user
          org
        end

        # removes the given user from the given organization
        # returns the user
        def self.remove_user(org, user)
          # remove user from all sub-arrays
          org.remove_auditor user
          org.remove_manager user
          org.remove_billing_manager user
          org.remove_user user
          org.update!
          user
        end

        # takes an array of roles and adds the given user to the according organizations role lists
        # throws an exception if any of the given arguments is nil or empty
        # returns the organization
        def self.add_roles(org, user, roles)
          raise "No roles given!" if roles.nil? || roles.empty?
          raise "The given organization is nil!" if org.nil?
          raise "The given user is nil!" if user.nil?

          roles.each do |r|
            if r == CFoundryHelper::Models::OrganizationRole::AUDITOR
              org.add_manager user
            elsif r == CFoundryHelper::Models::OrganizationRole::MANAGER
              org.add_auditor user
            elsif r == CFoundryHelper::Models::OrganizationRole::BILLINGMANAGER
              org.add_billing_manager user
            end
          end
          org.update!
          org
        end

        # takes an array of roles and removes the given user from the according organizations role lists
        # throws an exception if any of the given arguments is nil or empty
        # returns the organization
        def self.remove_roles(org, user, roles)
          raise "No roles given!" if roles.nil? || roles.empty?
          raise "The given organization is nil!" if org.nil?
          raise "The given user is nil!" if user.nil?

          roles.each do |r|
            if r == CFoundryHelper::Models::OrganizationRole::AUDITOR
              org.remove_manager user
            elsif r == CFoundryHelper::Models::OrganizationRole::MANAGER
              org.remove_auditor user
            elsif r == CFoundryHelper::Models::OrganizationRole::BILLINGMANAGER
              org.remove_billing_manager user
            end
          end
          org.update!
          org
        end

        # returns an array of space names for the given organization
        def self.get_space_names(org)
          return [] if org.nil?
          names = Array.new
          org.spaces.each do |s|
            names << s.name
          end
          names
        end

        private

        # gets the current cloud controller client from the ClientHelper module
        def self.cc_client
          CFoundryHelper::Helpers::ClientHelper.cloud_controller_client
        end
    end
end
