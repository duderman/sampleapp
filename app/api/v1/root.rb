module Sampleapp
  module Api
    module V1
      class Root < Grape::API
        version 'v1'

        get '/' do
          {}
        end

        mount Sampleapp::Api::V1::Profile
        mount Sampleapp::Api::V1::Posts
        mount Sampleapp::Api::V1::Comments
      end
    end
  end
end
