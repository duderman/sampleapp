module Sampleapp
  module Api
    module V1
      module Entities
        class User < Grape::Entity
          root 'users', 'user'

          expose :id, documentation: {
            type: :string, desc: ::User.attribute_description(:id)
          }
          expose :email, documentation: {
            type: :string, desc: ::User.attribute_description(:email)
          }
          expose :name, documentation: {
            type: :string, desc: ::User.attribute_description(:name)
          }
          expose :is_admin, documentation: {
            type: :boolean, desc: ::User.attribute_description(:is_admin)
          }

          expose :created_at, documentation: {
            type: :datetime, desc: ::User.attribute_description(:created_at)
          }
          expose :created_at, documentation: {
            type: :datetime, desc: ::User.attribute_description(:updated_at)
          }
        end
      end
    end
  end
end
