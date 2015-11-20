module Sampleapp
  module Api
    module V1
      autoload :Root, 'app/api/v1/root'
      autoload :Users, 'app/api/v1/users'

      autoload :Entities, 'app/api/v1/entities'
    end
  end
end
