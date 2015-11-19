require 'rack/test'
require 'rspec'

ENV['RACK_ENV'] = 'test'

require File.expand_path('../../app.rb', __FILE__)

Dir[Sampleapp::App.root.join('spec/support/**/*.rb')].each { |f| require f }

module RSpecMixin
  include Rack::Test::Methods
  def app
    Sinatra::Application
  end
end

RSpec.configure do |config|
  config.include RSpecMixin
  config.include FactoryGirl::Syntax::Methods

  config.mock_with :rspec
  config.order = :random
  Kernel.srand config.seed
end
