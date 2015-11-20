require './app'

run Rack::URLMap.new(
  '/' => Sampleapp::App,
  '/api' => Sampleapp::Api::Root
)
