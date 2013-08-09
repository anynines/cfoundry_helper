module CFoundryHelper::Models

  # This module lists the Roles available for organizations
  # There are 3 basic roles for organizations:
  # Manager: Can invite/manage users, select/change the plan, establish spending limits
  # Billing Manager: Can edit/change the billing account info, payment info
  # Auditor: View only access to all org and space info, settings, reports
  module OrganizationRole
    MANAGER = :manager
    BILLINGMANAGER = :billing_manager
    AUDITOR = :auditor

    def self.get_roles
      return [MANAGER, BILLINGMANAGER, AUDITOR]
    end

  end
end