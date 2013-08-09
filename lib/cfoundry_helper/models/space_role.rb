module CFoundryHelper::Models

  # This module lists the Roles available for spaces
  # There are 3 basic roles for spaces:
  # Manager: Can invite/manage users, enable features for a given space
  # Developer: Can create, delete, manage applications and services, full access to all usage reports and logs
  # Auditor: View only access to all space information, settings, reports, logs
  module SpaceRole
    MANAGER = :manager
    DEVELOPER = :developer
    AUDITOR = :auditor

    def self.get_roles
      return [MANAGER, DEVELOPER, AUDITOR]
    end

  end
end