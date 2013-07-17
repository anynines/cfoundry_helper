require_relative 'spec_helper'

describe 'This is my test that requires nats uaa and ccng', type: :integration, :components => [:nats, :ccng, :uaa] do
    # This is a helper module for accessing the cloud controller ng
    include CcngClient

    it 'start nats and ccng as required' do
      component(:nats).should be
      ccng_get('/v2/services').should be
    end
end
