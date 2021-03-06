module Sampleapp
  module Models
    class User < Sequel::Model
      plugin :secure_password

      one_to_many :posts, on_delete: :cascade
      one_to_many :comments, on_delete: :cascade

      ACCESSIBLE_PARAMS = [:name, :email].freeze

      def validate
        super
        validates_presence %i(email name password_digest created_at updated_at)
        validates_unique :email
        validates_format(/^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$/i, :email)
      end

      def admin?
        is_admin == true
      end

      def self.authenticate(email, password)
        user = where(email: email).first
        user && user.authenticate(password)
      end
    end
  end
end
