module Sampleapp
  module Api
    module V1
      class Comments < Grape::API
        authorize_routes!

        namespace '/posts/:post_id/comments' do
          enable_authentication

          helpers Sampleapp::Api::V1::Helpers::CommentsHelper

          desc 'Create comment'
          params do
            requires :post_id,
              type: String,
              desc: ::Post.attribute_description(:id),
              uuid: true
            requires :text,
              type: String,
              desc: ::Comment.attribute_description(:text)
          end
          post do
            set_post
            authorize! :create, Comment
            Comment.create(
              user: current_user,
              post: @post,
              text: params[:text]
            )
            { status: :ok, message: I18n.t('api.messages.created') }
          end

          namespace ':id' do
            desc 'Update comment'
            params do
              requires :post_id,
                type: String,
                desc: ::Post.attribute_description(:id),
                uuid: true
              requires :id,
                type: String,
                desc: ::Post.attribute_description(:id),
                uuid: true
              requires :text,
                type: String,
                desc: ::Comment.attribute_description(:text)
            end
            put do
              set_post
              set_comment
              authorize! :update, @comment
              @comment.update(text: params[:text])
              { status: :ok, message: I18n.t('api.messages.updated') }
            end

            desc 'Delete comment'
            params do
              requires :post_id,
                type: String,
                desc: ::Post.attribute_description(:id),
                uuid: true
              requires :id,
                type: String,
                desc: ::Post.attribute_description(:id),
                uuid: true
            end
            delete do
              set_post
              set_comment
              authorize! :delete, @comment
              @comment.destroy
              { status: :ok, message: I18n.t('api.messages.deleted') }
            end
          end
        end
      end
    end
  end
end
