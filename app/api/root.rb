module Sampleapp
  module Api
    autoload :V1, 'app/api/v1'
    autoload :ErrorFormatter, 'app/api/error_formatter'

    class Root < Grape::API
      prefix 'api'
      mount Sampleapp::Api::V1::Root
      error_formatter :json, Sampleapp::Api::ErrorFormatter
      use GrapeLogging::Middleware::RequestLogger, logger: Logger.new(STDOUT)

      before do
        I18n.locale = params[:locale] || I18n.default_locale
      end

      route :any do
        error!(I18n.t('grape.errors.page_not_found', path: request.path), 404)
      end

      route :any, '*path' do
        error!(I18n.t('grape.errors.page_not_found', path: request.path), 404)
      end
    end
  end
end
