module Sampleapp
  module Routes
    class Static < Sinatra::Application
      configure do
        set :views, 'app/views'
        set :root, App.root
        disable :method_override
        disable :protection
        enable :static
      end

      def static!
        return if (public_dir = settings.public_folder).nil?
        public_dir = File.expand_path(public_dir)

        path = File.expand_path(public_dir + unescape(request.path_info))
        return unless path.start_with?(public_dir) && File.file?(path)

        env['sinatra.static_file'] = path

        expire_static

        send_file path, disposition: nil
      end

      private

      def expire_static
        return if settings.development? || settings.test?

        expires ONE_YEAR, :public, max_age: ONE_YEAR
        headers 'Date' => Time.current.httpdate
      end
    end
  end
end
