Factory.sequence :email do |n|
  "user#{n+Time.now.to_i}@example.com"
end

Factory.sequence :username do |n|
  "user#{n}#{Time.now.to_i}"
end

Factory.define :user do |f|
  f.login {Factory.next(:username)}
  f.email {Factory.next(:email)}
  f.salted_password 'dcd09adae379018012f5b30e65dc5a8e8f044169'
  f.salt "f22c76aea1ee3faf5440369de1d4de539e4b4852"
  f.password 'password'
  f.firstname "First"
  f.lastname "Last"
end

Factory.define :event do |f|
  f.headline "foo"
  f.body "body"
  f.user {|user| user.association :user}
  f.approved true
  f.scheduled_time 1.day.from_now
end

Factory.define :project do |t|
  t.title "some title"
  t.url "http://www.example.com"
  t.source_url "http://bitbucket.org/mml/ruby_mn"
  t.description "some desc"
  t.user {|user| user.association(:user)}
end

Factory.define :opening do |t|
  t.headline "some opening"
  t.body "some body"
  t.user {|user| user.association :user}
end
Factory.define :for_hire do |t|
  t.blurb "some blurb"
  t.email "some@example.com"
  t.title "some title"
  t.user {|user| user.association :user}
end


