module Sampleapp
  module Api
    module V1
      module Entities
        class Comment < Grape::Entity
          root 'comments', 'comment'

          expose :id, documentation: {
            type: :string, desc: ::Comment.attribute_description(:id)
          }
          expose :user, using: Sampleapp::Api::V1::Entities::User, as: :author
          expose :text, documentation: {
            type: :string, desc: ::Comment.attribute_description(:text)
          }

          expose :created_at, documentation: {
            type: :datetime, desc: ::Comment.attribute_description(:created_at)
          }
          expose :updated_at, documentation: {
            type: :datetime, desc: ::Comment.attribute_description(:updated_at)
          }
        end
      end
    end
  end
end
