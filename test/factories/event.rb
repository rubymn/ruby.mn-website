FactoryGirl.define do
  factory :event do |f|
    headline { Faker::Lorem.sentence }
    body { Faker::Lorem.paragraph }
    approved true
    scheduled_time 1.day.from_now
    user
  end
end
