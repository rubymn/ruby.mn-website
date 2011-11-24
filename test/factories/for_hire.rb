FactoryGirl.define do
  factory :for_hire do |t|
    blurb { Faker::Lorem.paragraph }
    email { Faker::Internet.email }
    title { Faker::Lorem.sentence }
    user
  end
end
