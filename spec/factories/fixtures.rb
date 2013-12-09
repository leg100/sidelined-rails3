FactoryGirl.define do
  factory :fixture do
    association :home_club
    association :away_club
    datetime { Date.tomorrow }
  end
end
