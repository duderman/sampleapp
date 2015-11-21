module Grape::Authentication
  module Helpers
    def current_user
      @current_user
    end

    def authenticated?
      @current_user.present?
    end
  end
end
