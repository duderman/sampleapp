module Sampleapp
  module Api
    module V1
      module Helpers
        autoload :PostsHelper, 'app/api/v1/helpers/posts_helper'
        autoload :CommentsHelper, 'app/api/v1/helpers/comments_helper'
      end
    end
  end
end
