module CFoundryHelper::Helpers
  module SpaceHelper

    # creates a space with the given name within the given organization
    # throws an exception if the given spacename is nil or empty
    # throws an exception if the given organization is nil
    # throws an exception if a space with the given name already exists within the given organization
    def self.create_space(org, spacename)
      raise "The given organization is nil!" if org.nil?
      raise "The given spacename is nil!" if spacename.nil?
      raise "The given spacename is empty!" if spacename.eql?('')
      raise "The #{spacename} space already exists within #{org.name}!" if self.exists?(org, spacename)

      space = self.cc_client.space
      space.name = spacename
      space.organization = org
      space.create!
      space
    end

    # deletes a space
    # throws an exception if the given space is nil
    # throws an exception if the given space is not empty
    # returns true on deletion
    def self.delete_space(space)
      raise "The given space is nil!" if space.nil?
      if space.apps.count > 0 || space.service_instances.count > 0
        raise "The given space is not empty!"
      end
      space.delete!
      return true
    end

    # deletes all app instances and services from the given space
    # deletes all routes from the given space
    # throws an exception if the given space is nil
    def self.empty_space(space)
      raise "The given space is nil!" if space.nil?

      #TODO: bugfix

      # delete apps
      while !space.apps.first.nil?
        space.apps.first.delete!
      end

      # delete service instances
      while !space.service_instances.first.nil? && !space.service_instances.first.name.eql?('')
        space.service_instances.first.delete!
      end

      while !space.domains.first.nil?
        space.remove_domain space.domains.first
      end

      space.update!
      space
    end

    # returns the given the space with the given name within the given organization
    # returns nil of no space has been found
    def self.get_space(org, spacename)
      org.space_by_name spacename
    end

    # returns the space with the given name in the organization with the given name
    # returns nil if no space has been found
    def self.get_space_by_name(org_name, space_name)
      org = CFoundryHelper::Helpers::OrganizationHelper.get_organization_by_name org_name
      return nil if org.nil?
      return self.get_space(org, space_name)
    end

    # returns true if a space with the given name exists within the given organization
    # returns false if no space with the given name exists within the given organization
    def self.exists?(org, spacename)
      return !org.space_by_name(spacename).nil?
    end

    # takes an array of roles and adds the given user to the according space's role lists
    # throws an exception if any of the given arguments is nil or empty
    # throws an exception if the given user is not registered with the space's organization
    # returns the space
    def self.add_roles(space, user, roles)
      raise "No roles given!" if roles.nil? || roles.empty?
      raise "The given space is nil!" if space.nil?
      raise "The given user is nil!" if user.nil?

      roles.each do |r|
        if r == CFoundryHelper::Models::SpaceRole::MANAGER
          space.add_manager user
        elsif r == CFoundryHelper::Models::SpaceRole::AUDITOR
          space.add_auditor user
        elsif r == CFoundryHelper::Models::SpaceRole::DEVELOPER
          space.add_developer user
        end
      end
      space.update!
      space
    end

    # takes an array of roles and removes the given user from the according space role lists
    # throws an exception if any of the given arguments is nil or empty
    # returns the space
    def self.remove_roles(space, user, roles)
      raise "No roles given!" if roles.nil? || roles.empty?
      raise "The given space is nil!" if space.nil?
      raise "The given user is nil!" if user.nil?

      roles.each do |r|
        if r == CFoundryHelper::Models::SpaceRole::MANAGER
          space.remove_manager user
        elsif r == CFoundryHelper::Models::SpaceRole::AUDITOR
          space.remove_auditor user
        elsif r == CFoundryHelper::Models::SpaceRole::DEVELOPER
          space.remove_developer user
        end
      end
      space.update!
      space
    end

    # gets the current cloud controller client from the ClientHelper module
    def self.cc_client
      CFoundryHelper::Helpers::ClientHelper.cloud_controller_client
    end
  end
end