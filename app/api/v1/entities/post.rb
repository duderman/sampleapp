module Sampleapp
  module Api
    module V1
      module Entities
        class Post < Grape::Entity
          root 'posts', 'post'

          expose :id, documentation: {
            type: :string, desc: ::Post.attribute_description(:id)
          }
          expose :user, using: Sampleapp::Api::V1::Entities::User, as: :author
          expose :body, documentation: {
            type: :string, desc: ::Post.attribute_description(:body)
          } do |post, options|
            if options[:full] || post.body.length < ::Post::PREVIEW_LENGTH
              post.body
            else
              "#{post.body[0..::Post::PREVIEW_LENGTH]}..."
            end
          end

          expose :created_at, documentation: {
            type: :datetime, desc: ::Post.attribute_description(:created_at)
          }
          expose :updated_at, documentation: {
            type: :datetime, desc: ::Post.attribute_description(:updated_at)
          }

          expose :comments, using: Sampleapp::Api::V1::Entities::Comment,
                            if: :full
          expose :comments_count, unless: :full do |post|
            post[:comments_count] || post.comments.count
          end
        end
      end
    end
  end
end
