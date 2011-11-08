FactoryGirl.define do
  sequence :email do |n|
    "user#{n+Time.now.to_i}@example.com"
  end

  sequence :username do |n|
    "user#{n}#{Time.now.to_i}"
  end
end
