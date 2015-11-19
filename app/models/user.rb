module Sampleapp
  module Models
    class User < Sequel::Model
      plugin :secure_password

      def validate
        super
        validates_presence %i(email name password_digest created_at updated_at)
        validates_unique :email
      end

      def admin?
        is_admin == true
      end
    end
  end
end
