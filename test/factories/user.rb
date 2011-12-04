FactoryGirl.define do
  factory :user do |f|
    login { Factory.next(:username) }
    email { Factory.next(:email) }
    salted_password 'dcd09adae379018012f5b30e65dc5a8e8f044169'
    salt "f22c76aea1ee3faf5440369de1d4de539e4b4852"
    password 'password'
    password_confirmation { |u|  u.password }
    firstname { Faker::Name.first_name }
    lastname { Faker::Name.last_name }

    factory :admin do |f|
      login 'admin'
      firstname 'Admin'
      lastname 'User'
      verified true
    end
  end
end