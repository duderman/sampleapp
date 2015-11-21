module Sampleapp
  module Api
    module V1
      class Comments < Grape::API
        authorize_routes!

        namespace '/posts/:post_id/comments' do
          before do
            @post = Post.where(id: params[:post_id]).first
            error!(I18n.t('api.errors.not_found'), 404) unless @post
          end

          desc 'Create comment'
          requires_authentication
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
            authorize! :create, Comment
            Comment.create(
              user: current_user,
              post: @post,
              text: params[:text]
            )
            { status: :ok, message: I18n.t('api.messages.created') }
          end

          namespace ':id' do
            before do
              @comment = Comment.where(id: params[:id]).first
              error!(I18n.t('api.errors.not_found'), 404) unless @comment
            end

            desc 'Update comment'
            requires_authentication
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
              authorize! :update, @comment
              @comment.update(text: params[:text])
              { status: :ok, message: I18n.t('api.messages.updated') }
            end

            desc 'Delete comment'
            requires_authentication
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
