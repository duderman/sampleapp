module Sampleapp
  module Api
    module V1
      class Users < Grape::API
        namespace :users do
          desc 'Shows all users',
            params: Sampleapp::Api::V1::Entities::User.documentation
          get do
            present User.all, with: Sampleapp::Api::V1::Entities::User
          end
        end
      end
    end
  end
end
