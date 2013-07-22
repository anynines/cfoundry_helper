module CFoundryHelper::Models
  module SpaceRole
    MANAGER = :manager
    DEVELOPER = :developer
    AUDITOR = :auditor

    def self.get_roles
      return [MANAGER, DEVELOPER, AUDITOR]
    end

  end
end