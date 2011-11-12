FactoryGirl.define do
  factory :event do |f|
    headline "foo"
    body "body"
    approved true
    scheduled_time 1.day.from_now
    user
  end
end
