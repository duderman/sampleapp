module Sampleapp
  module Models
    class Post < Sequel::Model
      many_to_one :user
      one_to_many :comments, on_delete: :cascade

      def validate
        super
        validates_presence %i(user body created_at updated_at)
      end
    end
  end
end
