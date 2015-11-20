FactoryGirl.define do
  factory :post do
    user
    body { FFaker::Lorem.paragraph }
  end
end
