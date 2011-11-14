FactoryGirl.define do
  factory :opening do |t|
    headline { Faker::Lorem.sentence }
    body { Faker::Lorem.paragraph }
    user
  end
end
