require 'rubygems'
require 'bundler'

# Setup load paths
Bundler.require
$LOAD_PATH << File.expand_path('../', __FILE__)
$LOAD_PATH << File.expand_path('../lib', __FILE__)

require 'dotenv'
Dotenv.load

require 'sinatra/base'

Dir['lib/**/*.rb'].sort.each { |file| require file }

require 'app/extensions'
require 'app/models'
require 'app/helpers'
require 'app/routes'

module Sampleapp
  class App < Sinatra::Application
    configure do
      set :database, lambda {
        ENV['DATABASE_URL'] ||
          "postgres://localhost:5432/sampleapp_#{environment}"
      }
    end

    configure :development, :staging do
      database.loggers << Logger.new(STDOUT)
    end

    configure do
      disable :method_override
      disable :static

      set :erb, escape_html: true

      set :sessions,
          httponly: true,
          secure: production?,
          expire_after: 5.years,
          secret: ENV['SESSION_SECRET']
    end

    use Rack::Deflater
    use Rack::Standards
    use Routes::Static
    use Routes::Assets unless settings.production?

    # use Routes::Posts
  end
end

include Sampleapp::Models
