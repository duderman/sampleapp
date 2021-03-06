module Sampleapp
  module Api
    autoload :V1, 'app/api/v1'
    autoload :ErrorFormatter, 'app/api/error_formatter'
    require 'app/api/validators'

    class Root < Grape::API
      format :json

      error_formatter :json, Sampleapp::Api::ErrorFormatter

      if ENV['RACK_ENV'] != 'test'
        logger LoggerBuilder.new('api', level: :debug).build
        use Sampleapp::Api::Logger
      end

      helpers do
        def logger
          Sampleapp::Api::Root.logger
        end

        def page_not_found_error!
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

      before do
        I18n.locale = params[:locale] || I18n.default_locale
        header['Access-Control-Allow-Origin'] = '*'
        header['Access-Control-Request-Method'] = '*'
      end

      rescue_from Sequel::ValidationFailed do |e|
        response = ErrorFormatter.call(
          I18n.t(
            'api.errors.cant_save_record',
            errors: e.model.errors.full_messages.join(', ')
          ),
          e.backtrace, nil, env
        )
        Rack::Response.new(
          [response],
          422,
          'Content-Type' => 'application/json'
        ).finish
      end

      rescue_from CanCan::AccessDenied do |e|
        response = ErrorFormatter.call(
          I18n.t('api.errors.you_dont_have_access'),
          e.backtrace, nil, env
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

      route(:any) { page_not_found_error! }
      route(:any, '*path') { page_not_found_error! }
    end
  end
end
