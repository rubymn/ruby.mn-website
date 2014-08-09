FactoryGirl.define do
  factory :sponsor do |f|
    name { Faker::Company.name }
    description { Faker::Lorem.sentence }
    current { [true, false].sample }
  end
end
