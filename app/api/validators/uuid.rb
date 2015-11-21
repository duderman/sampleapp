module Sampleapp
  module Api
    module Validators
      class Uuid < Grape::Validations::Validator
        UUID_REGEX = /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i

        def validate_param!(attr_name, params)
          return if params[attr_name] =~ UUID_REGEX
          fail Grape::Exceptions::Validation,
            params: [@scope.full_name(attr_name)],
            message: I18n.t('api.errors.wrong_uuid_format')
        end
      end
    end
  end
end
