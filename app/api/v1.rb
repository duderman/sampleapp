module Sampleapp
  module Api
    module V1
      autoload :Root, 'app/api/v1/root'
      autoload :Profile, 'app/api/v1/profile'
      autoload :Posts, 'app/api/v1/posts'
      autoload :Comments, 'app/api/v1/comments'

      autoload :Entities, 'app/api/v1/entities'
    end
  end
end
