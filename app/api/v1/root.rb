module Sampleapp
  module Api
    module V1
      class Root < Grape::API
        version 'v1'

        get '/' do
          {}
        end

        mount Sampleapp::Api::V1::Users
        mount Sampleapp::Api::V1::Profile
        mount Sampleapp::Api::V1::Posts
      end
    end
  end
end
