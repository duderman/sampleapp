module Sampleapp
  module Api
    module V1
      class Profile < Grape::API
        namespace :profile do
          enable_authentication

          desc 'Shows users profile',
            params: Sampleapp::Api::V1::Entities::User.documentation
          get do
            present @current_user, with: Sampleapp::Api::V1::Entities::User
          end

          desc 'Update info'
          params do
            User::ACCESSIBLE_PARAMS.each do |attr|
              optional attr, type: String
            end
          end
          put do
            @current_user.update(params.slice(*User::ACCESSIBLE_PARAMS))
            present @current_user, with: Sampleapp::Api::V1::Entities::User
          end

          desc 'Change password'
          params do
            requires :password, type: String
            requires :confirmation, type: String
          end
          put :change_password do
            @current_user.update(
              password: params[:password],
              password_confirmation: params[:confirmation]
            )
            { status: :ok, message: I18n.t('api.profile.password_changed') }
          end
        end
      end
    end
  end
end
