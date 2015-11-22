module Sampleapp
  module Models
    class Post < Sequel::Model
      PREVIEW_LENGTH = 100

      many_to_one :user
      one_to_many :comments, on_delete: :cascade,
                             order: Sequel.desc(:created_at)

      def validate
        super
        validates_presence %i(user body created_at updated_at)
      end

      def body_preview
        if body.length > PREVIEW_LENGTH
          "#{body[0..PREVIEW_LENGTH]}..."
        else
          body
        end
      end
    end
  end
end
