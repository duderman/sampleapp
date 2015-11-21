require 'rack/test'
require 'rspec'

ENV['RACK_ENV'] = 'test'

require File.expand_path('../../app.rb', __FILE__)

Dir[Sampleapp::App.root.join('spec/support/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include RspecSequel::Matchers

  config.mock_with :rspec
  config.order = :random
  Kernel.srand config.seed
end
