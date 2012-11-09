# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event_registration do
      event_id 1
      user_id 1
      email "MyString"
    end
end