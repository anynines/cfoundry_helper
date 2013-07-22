module CFoundryHelper::Helpers
  autoload :OrganizationHelper, File.expand_path('../helpers/organization_helper', __FILE__)
  autoload :ClientHelper, File.expand_path('../helpers/client_helper', __FILE__)
  autoload :UserHelper, File.expand_path('../helpers/user_helper', __FILE__)
  autoload :SpaceHelper, File.expand_path('../helpers/space_helper', __FILE__)
end