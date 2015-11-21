module Sampleapp
  module Api
    module V1
      class Posts < Grape::API
        resource :posts
        authorize_routes!

        helpers Sampleapp::Api::V1::Helpers::PostsHelper

        desc 'Shows all posts'
        paginate
        get '/', authorize: [:read, Post] do
          posts = Post.association_left_join(:comments)
                  .eager(:user)
                  .select_all(:posts)
                  .select_append { count(comments__id).as(comments_count) }
                  .group(:posts__id)
                  .reverse_order(:created_at)
                  .extension(:pagination)
          present paginate(posts).all,
            with: Sampleapp::Api::V1::Entities::Post,
            full: false
        end

        desc 'Shows specific post'
        params do
          requires :id, type: String,
                        desc: ::Post.attribute_description(:id),
                        uuid: true
        end
        get ':id' do
          set_post
          authorize! :read, @post
          render_post
        end

        enable_authentication

        desc 'Create post'
        params do
          requires :body,
            type: String,
            desc: ::Post.attribute_description(:body)
        end
        post '/', authorize: [:create, Post] do
          @post = Post.create(user: current_user, body: params[:body])
          render_post
        end

        desc 'Update post'
        params do
          requires :id,
            type: String,
            desc: ::Post.attribute_description(:id),
            uuid: true
          requires :body,
            type: String,
            desc: ::Post.attribute_description(:body)
        end
        put ':id' do
          set_post
          authorize! :update, @post
          @post.update(body: params[:body])
          render_post
        end

        desc 'Delete post'
        params do
          requires :id,
            type: String,
            desc: ::Post.attribute_description(:id),
            uuid: true
        end
        delete ':id' do
          set_post
          authorize! :delete, @post
          @post.destroy
          { status: :ok, message: I18n.t('api.messages.deleted') }
        end
      end
    end
  end
end
