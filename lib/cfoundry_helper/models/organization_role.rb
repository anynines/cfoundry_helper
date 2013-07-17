module CFoundryHelper::Models
  module OrganizationRole
    MANAGER = :manager
    BILLINGMANAGER = :billing_manager
    AUDITOR = :auditor

    def self.get_roles
      return [MANAGER, BILLINGMANAGER, AUDITOR]
    end

  end
end