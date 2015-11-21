module Sampleapp
  module Api
    module V1
      class Posts < Grape::API
        resource :posts
        authorize_routes!

        helpers do
          def render_post
            if @post.is_a?(Post)
              @post = Post.where(id: @post.id).eager(:comments).first
            end
            present @post, with: Sampleapp::Api::V1::Entities::Post, full: true
          end
        end

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

        desc 'Create post'
        requires_authentication
        params do
          requires :body,
            type: String,
            desc: ::Post.attribute_description(:body)
        end
        post '/', authorize: [:create, Post] do
          @post = Post.create(user: current_user, body: params[:body])
          render_post
        end

        namespace ':id' do
          before do
            @post = Post.where(id: params[:id]).first
            error!(I18n.t('api.errors.not_found'), 404) unless @post
          end

          desc 'Shows specific post'
          params do
            requires :id, type: String,
                          desc: ::Post.attribute_description(:id),
                          uuid: true
          end
          get do
            authorize! :read, @post
            render_post
          end

          desc 'Update post'
          requires_authentication
          params do
            requires :id,
              type: String,
              desc: ::Post.attribute_description(:id),
              uuid: true
            requires :body,
              type: String,
              desc: ::Post.attribute_description(:body)
          end
          put do
            authorize! :update, @post
            @post.update(body: params[:body])
            render_post
          end

          desc 'Delete post'
          requires_authentication
          params do
            requires :id,
              type: String,
              desc: ::Post.attribute_description(:id),
              uuid: true
          end
          delete do
            authorize! :delete, @post
            @post.destroy
            { status: :ok, message: I18n.t('api.messages.deleted') }
          end
        end
      end
    end
  end
end
