FactoryGirl.define do
  factory :comment do
    user
    post
    text { FFaker::Lorem.sentence }
  end
end
