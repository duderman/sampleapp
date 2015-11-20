# Api logger
#
# TODO: Refactor
class Sampleapp::Api::Logger < Grape::Middleware::Base
  HEADERS_BLACKLIST = ['HTTP_COOKIE'].freeze

  class Grape::Middleware::Error
    def call!(env)
      @env = env

      begin
        log_error_response do
          error_response(catch(:error) do
            return @app.call(@env)
          end)
        end
      rescue StandardError => e
        is_rescuable = rescuable?(e.class)
        if e.is_a?(Grape::Exceptions::Base) && !is_rescuable
          handler = ->(arg) { error_response(arg) }
        else
          raise unless is_rescuable
          handler = find_handler(e.class)
        end

        handler.nil? ? handle_error(e) : exec_handler(e, &handler)
      end
    end

    def log_error_response(&block)
      start = Time.now
      result = block.call
      stop = Time.now

      milliseconds_taken ||= ((stop - start) * 1000).to_i

      response_status = result[0]
      response_headers = result[1]
      response_headers = response_headers.
        select { |k, _v| k.start_with?('HTTP_') && !::Sampleapp::Api::Logger::HEADERS_BLACKLIST.include?(k) }.
        collect { |pair| [pair[0].sub(/^HTTP_/, ''), pair[1]] }.
        collect { |pair| pair.join(': ') }.
        sort

      parts = []
      result[2].each { |part| parts << part }
      response_body = parts.join

      ::Sampleapp::Api::Root.logger.debug "Response headers: #{response_headers}"
      ::Sampleapp::Api::Root.logger.debug "Response body: #{response_body}"
      ::Sampleapp::Api::Root.logger.debug "Completed #{response_status} in #{milliseconds_taken}ms"

      result
    end
  end

  def before
    @start = Time.now

    ::Sampleapp::Api::Root.logger.debug "Started #{request_method} \"#{request_target}\" for #{request_ip} at #{Time.now}"
    ::Sampleapp::Api::Root.logger.debug "Request headers: #{request_headers}"
    ::Sampleapp::Api::Root.logger.debug "Request body: #{request_params}"
    ::Sampleapp::Api::Root.logger.debug "Source: #{source_file}:#{source_line}"
  end

  def after
    @stop = Time.now

    ::Sampleapp::Api::Root.logger.debug "Response headers: #{response_headers}"
    ::Sampleapp::Api::Root.logger.debug "Response body: #{response_body}"
    ::Sampleapp::Api::Root.logger.debug "Completed #{response_status} in #{milliseconds_taken}ms"

    @app_response
  end

  private

  def response_status
    @app_response[0]
  end

  def response_headers
    @app_response[1]
  end

  def response_body
    parts = []
    @app_response[2].each { |part| parts << part }
    parts.join
  end

  def milliseconds_taken
    @milliseconds_taken ||= ((@stop - @start) * 1000).to_i
  end

  def request_log_data
    @request_log_data ||= create_request_log_data
  end

  def request_method
    env['REQUEST_METHOD']
  end

  def request_target
    env['PATH_INFO']
  end

  def request_ip
    env['REMOTE_ADDR']
  end

  def request_headers
    headers = env.select { |k, _v| k.start_with?('HTTP_') && !HEADERS_BLACKLIST.include?(k) }
              .collect { |pair| [pair[0].sub(/^HTTP_/, ''), pair[1]] }
              .collect { |pair| pair.join(': ') }
              .sort
  end

  def request_params
    env['rack.input'].read
  end

  def source_file
    env['api.endpoint'].source.source_location[0][(Sampleapp::App.root.to_s.length + 1)..-1]
  end

  def source_line
    env['api.endpoint'].source.source_location[1]
  end
end
