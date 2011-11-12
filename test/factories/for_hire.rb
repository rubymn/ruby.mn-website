FactoryGirl.define do
  factory :for_hire do |t|
    blurb "some blurb"
    email "some@example.com"
    title "some title"
    user
  end
end