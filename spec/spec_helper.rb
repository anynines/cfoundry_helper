lib = File.expand_path("../..", __FILE__)
$LOAD_PATH.unshift lib unless $LOAD_PATH.include?(lib)

require 'vendor/integration-test-support/support/integration_example_group.rb'

IntegrationExampleGroup.tmp_dir = '/tmp'

RSpec.configure do |config|
   config.include IntegrationExampleGroup, type: :integration
end
