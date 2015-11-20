module Sampleapp
  module Api
    module V1
      class Root < Grape::API
        version 'v1'

        get '/' do
          {}
        end

        mount Sampleapp::Api::V1::Users
      end
    end
  end
end
