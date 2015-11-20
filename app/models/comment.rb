module Sampleapp
  module Models
    class Comment < Sequel::Model
      many_to_one :user
      many_to_one :post

      def validate
        super
        validates_presence %i(user post text created_at updated_at)
      end
    end
  end
end
