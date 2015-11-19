module Sampleapp
  module Models
    class User < Sequel::Model
      plugin :secure_password

      def admin?
        is_admin == true
      end
    end
  end
end
