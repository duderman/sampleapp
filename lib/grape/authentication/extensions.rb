module Grape::Authentication
  module Extensions
    def requires_authentication
      http_basic do |email, pass|
        @current_user = User.authenticate(email, pass)
      end
    end
  end
end
