FactoryGirl.define do
  factory :project do |t|
    title "some title"
    url "http://www.example.com"
    source_url "http://bitbucket.org/mml/ruby_mn"
    description "some desc"
    user
  end
end