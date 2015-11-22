module Sampleapp
  module Api
    module V1
      module Helpers
        module PostsHelper
          extend Grape::API::Helpers

          def set_post
            @post = Post.where(id: params[:id]).first
            error!(I18n.t('api.errors.not_found'), 404) unless @post
          end

          def render_post
            if @post.is_a?(Post)
              @post = Post.where(id: @post.id).eager(:comments).first
            end
            present @post, with: Sampleapp::Api::V1::Entities::Post, full: true
          end
        end
      end
    end
  end
end
