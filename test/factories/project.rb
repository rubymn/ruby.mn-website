FactoryGirl.define do
  factory :project do |t|
    title { Faker::Lorem.sentence }
    url { "http://#{Faker::Internet.domain_name}" }
    source_url { "http://#{Faker::Internet.domain_name}/#{Faker::Lorem.words(1).first}" }
    description { Faker::Lorem.paragraph }
    user
  end
end
