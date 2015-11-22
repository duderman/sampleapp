require 'grape'

module Grape
  module Authentication
    autoload :Extensions, 'grape/authentication/extensions'
    autoload :Helpers, 'grape/authentication/helpers'

    Grape::Endpoint.send :include, Grape::Authentication::Helpers
    Grape::API.send :extend, Grape::Authentication::Extensions
  end
end
