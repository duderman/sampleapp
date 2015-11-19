require './app'

run Rack::Cascade.new [Sampleapp::App, Sampleapp::Api::Root]
