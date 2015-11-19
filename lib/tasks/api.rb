namespace :api do
  desc 'Shows API Routes'
  task routes: :environment do
    Sampleapp::Api::Root.routes.each do |api|
      method = api.route_method.to_s.ljust(10)
      path = api.route_path.to_s.gsub(':version', api.route_version.to_s)
      puts "     #{method} #{path}"
    end
  end
end
