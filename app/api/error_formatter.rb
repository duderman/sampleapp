module Sampleapp
  module Api
    module ErrorFormatter
      def self.call(message, backtrace, _options, _env)
        answer = {
          status: :error,
          message: message
        }

        if ENV['RACK_ENV'] != 'production' && backtrace.present?
          answer.merge!(backtrace: backtrace)
        end

        answer.to_json
      end
    end
  end
end
