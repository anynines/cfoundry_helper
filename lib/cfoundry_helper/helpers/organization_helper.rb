module CFoundryHelper::Helpers
    module OrganizationHelper

        def self.set_client(client)

        end

        # creates an CFoundry::V2::Organization with the given attributes contained in the hash
        # returns the created organization
        # throws an exception when an error occures during creating the organization
        def self.create_organization(attributes)

        end

        # returns the organization with the given name if it exists
        # throws an exception when the given organization doesn't exist
        def self.get_organization_by_name(name)

        end

        # returns an array of Cfoundry::V2::Users registered within the given organization
        def self.get_users(org)

        end

        # adds the given user to the given organization
        def self.add_user(org, user)

        end

        # adds the user with the given email to the given organization
        def self.add_user_by_email(org, email)

        end

        # removes the given user from the given organization
        def self.remove_user(org, user)

        end

        # takes an array of roles and adds the given user to the according organizations role lists
        def self.add_roles(org, user, roles)

        end

        # takes an array of roles and removes the given user from the according organizations role lists
        def self.remove_roles(org, user, roles)

        end
    end
end