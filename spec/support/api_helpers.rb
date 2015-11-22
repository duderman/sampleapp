module ApiHelpers
  def app
    Sampleapp::Api::Root
  end

  def json
    @json ||= MultiJson.load(last_response.body, symbolize_keys: true)
  end

  def authenticate_user(user)
    basic_authorize user.email, user.password
  end
end

RSpec.configure do |config|
  config.include ApiHelpers, type: :api
  config.include Rack::Test::Methods, type: :api
end
