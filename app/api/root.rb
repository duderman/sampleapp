module Sampleapp
  module Api
    autoload :V1, 'app/api/v1'
    autoload :ErrorFormatter, 'app/api/error_formatter'
    require 'app/api/validators'

    class Root < Grape::API
      format :json

      error_formatter :json, Sampleapp::Api::ErrorFormatter

      logger LoggerBuilder.new('api', level: :debug).build
      use Sampleapp::Api::Logger
      helpers do
        def logger
          Sampleapp::Api::Root.logger
        end
      end

      before do
        I18n.locale = params[:locale] || I18n.default_locale
      end

      rescue_from Sequel::ValidationFailed do |e|
        error_response(
          message: I18n.t(
            'api.errors.cant_save_record',
            errors: e.model.errors.full_messages.join(', ')
          )
        )
      end

      rescue_from CanCan::AccessDenied do
        response = ErrorFormatter.call(
          I18n.t('api.errors.you_dont_have_access'),
          nil, nil, env
        )
        Rack::Response.new(
          [response],
          403,
          'Content-Type' => 'application/json'
        ).finish
      end

      rescue_from :all do |e|
        error_response(message: I18n.t(
          'api.errors.unknown_error', error: e.message
        ), backtrace: e.backtrace)
      end

      mount Sampleapp::Api::V1::Root

      route :any do
        error!(
          I18n.t(
            'api.errors.page_not_found',
            path: request.path,
            method: request.method
          ),
          404
        )
      end

      route :any, '*path' do
        error!(
          I18n.t(
            'api.errors.page_not_found',
            path: request.path,
            method: env['REQUEST_METHOD']
          ),
          404
        )
      end
    end
  end
end
