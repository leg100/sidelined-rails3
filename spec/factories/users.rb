require 'faker'

FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password(8) }
    password_confirmation { password }
    confirmed_at { Date.yesterday }

    factory :admin do
      admin true
    end
  end
end
