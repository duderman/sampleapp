module Sampleapp
  module Api
    module V1
      class Root < Grape::API
        version 'v1'

        get '/' do
          {}
        end
      end
    end
  end
end
