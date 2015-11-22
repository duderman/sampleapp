module Sampleapp
  module Api
    module V1
      module Helpers
        module CommentsHelper
          extend Grape::API::Helpers

          def set_post
            @post = Post.where(id: params[:post_id]).first
            error!(I18n.t('api.errors.not_found'), 404) unless @post
          end

          def set_comment
            @comment = Comment.where(id: params[:id]).first
            error!(I18n.t('api.errors.not_found'), 404) unless @comment
          end
        end
      end
    end
  end
end
