require 'rubygems'
require 'bundler'

# Setup load paths
Bundler.require :default, (ENV['RACK_ENV'] || :development)
$LOAD_PATH << File.expand_path('../', __FILE__)
$LOAD_PATH << File.expand_path('../lib', __FILE__)

Dotenv.load

require 'sinatra/base'

Dir['config/initializers/*.rb'].sort.each { |file| require file }
Dir['lib/**/*.rb'].sort.each { |file| require file }

require 'app/extensions'
require 'app/models'
require 'app/ability'
require 'app/helpers'
require 'app/routes'
require 'app/api'

module Sampleapp
  # Main sinatra module
  class App < Sinatra::Application
    configure do
      set :database, lambda {
        ENV['DATABASE_URL'] ||
          "postgres://localhost:5432/sampleapp_#{environment}"
      }

      set :root, Pathname.new(File.expand_path('..', __FILE__))

      set :logger, LoggerBuilder.new.build
      enable :logging
      use Rack::CommonLogger,
          LoggerBuilder.new(settings.environment, stdout: false).build

      disable :method_override
      disable :static

      set :erb, escape_html: true

      set :sessions,
          httponly: true,
          secure: production?,
          expire_after: SESSION_EXPIRATION_TIME,
          secret: ENV['SESSION_SECRET']
    end

    configure :development, :staging do
      database.loggers << LoggerBuilder.new('database').build
    end

    helpers do
      def logger
        settings.logger
      end
    end

    use Rack::Deflater
    use Rack::Standards
    use Routes::Static
    use Routes::Assets unless settings.production?
  end
end

include Sampleapp::Models
