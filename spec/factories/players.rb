require 'faker'

FactoryGirl.define do
  factory :player do
    club
    short_name "MLT"
    long_name { Faker::Name.name }
    forename "Matt"
    surname "Le Tissier"
    forenames %w[Matt] 
    surnames %w[Le Tissier]
  end
end
