# preparation) start the console using: bundle exec rake c

# connect to cc & uaa
CFoundryHelper.load_config_from_file "config/services.yml"
CFoundryHelper::Helpers::ClientHelper.current_target_url = CFoundryHelper.available_targets.first

# get the infos
email = "testemail@example.com"
user = CFoundryHelper::Helpers::UserHelper.get_user_by_email email
orgs = user.organizations

# puts orgs and spaces
orgs.each do |org|
     puts org.name
     puts "Spaces:"
     puts ""
     org.spaces.each do |sp|
          puts sp.name
     end
     puts ""
end

# delete all orgs recursively
orgs.each do |org|
     puts "Deleting: #{org.name}"
     CFoundryHelper::Helpers::OrganizationHelper.delete_organization_recursive(org)
end

# delete the user
puts "Deleting the user with email: #{email}"
user.delete!
