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

        add_swagger_documentation(
          format: :json,
          api_version: '1.0.0',
          base_path: '/api/v1/',
          info: {
            title: 'Sampleapp',
            description: 'Sample grape app with entities'
          },
          models: [
            Sampleapp::Api::V1::Entities::User,
            Sampleapp::Api::V1::Entities::Post,
            Sampleapp::Api::V1::Entities::Comment
          ]
        )
      end
    end
  end
end
