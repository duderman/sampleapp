module Sampleapp
  module Api
    module V1
      module Entities
        autoload :User, 'app/api/v1/entities/user'
        autoload :Post, 'app/api/v1/entities/post'
        autoload :Comment, 'app/api/v1/entities/comment'
      end
    end
  end
end
