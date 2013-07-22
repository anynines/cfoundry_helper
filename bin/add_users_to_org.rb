#!/usr/bin/ruby
require_relative '../lib/cfoundry_helper'

# function definitions ---------------------------------------------
def print_help
  puts "You have entered a wrong number of arguments!"
  puts "Usage: add_users_to_org.rb <organization name> <user list file location>"
end

def add_user_to_org(org, email)
  user = CFoundryHelper::Helpers::UserHelper.get_user_by_email email
  CFoundryHelper::Helpers::OrganizationHelper.add_user org, user
  CFoundryHelper::Helpers::OrganizationHelper.add_roles org, user,
    [CFoundryHelper::Models::OrganizationRole::AUDITOR, CFoundryHelper::Models::OrganizationRole::MANAGER]
end

def check_users_present(file_loc)
  all_existing = true
  File.open(file_loc).each do |email|
    email = email.strip
    puts "Checking email=#{email} ...."
    unless CFoundryHelper::Helpers::UserHelper.email_exists? email
      puts "The user email=#{email} doesn't exist in the system!"
      all_existing = false
    end
  end
  if all_existing
    puts "All emails are present in the system!"
  else
    puts "Some emails are not present in the system!"
  end
  all_existing
end

def add_users(org_name, file_loc)
  org = CFoundryHelper::Helpers::OrganizationHelper.get_organization_by_name org_name
  if org.nil?
    puts "No organization with the name=#{org_name} could be found!"
    exit(-1)
  end
  puts "Adding users to the #{org_name} organization!"

  File.open(file_loc).each do |email|
    email = email.strip
    puts "Adding user with email=#{email}"
    add_user_to_org org, email
  end

  puts "Finished adding users!"
end

def print_rails_env
  puts "RAILS_ENV=#{ENV["RAILS_ENV"]}"
end

# execute script ----------------------------------------------

if ARGV.count < 2
  print_help
  exit(-1)
end

puts "add users to organization"
print_rails_env

organization_name = ARGV[0]
file_loc = ARGV[1]

unless check_users_present(file_loc)
  puts "Canceling operation!"
  exit(-1)
end

add_users(organization_name, file_loc)









