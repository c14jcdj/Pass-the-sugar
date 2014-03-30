FactoryGirl.define do
  factory :record do
    created_at { Time.now }
    glucose "123"
    weight "100"
    taken_at { Time.now }
  end

  factory :diabetic do
    sequence(:name) { |n| Faker::Name.name + n.to_s }
    sequence(:email) { |n| n.to_s + Faker::Internet.email }
    birthday { Date.today - rand(2000) }
    account
  end

  factory :account do
    username 'test'
    email 'testing@testing.com'
    password 'testing'
    password_confirmation 'testing'
  end

  factory :doctor do
    sequence(:name) { |n| Faker::Name.name + n.to_s }
    sequence(:fax) { |n| Faker::PhoneNumber.phone_number + n.to_s }
    sequence(:email) { |n| n.to_s + Faker::Internet.email }
    comments Faker::Lorem.sentence
  end

  factory :preference do
    reminders [true, false].sample
    frequency [1,2,3].sample
  end

end
