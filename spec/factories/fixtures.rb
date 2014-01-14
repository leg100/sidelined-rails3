FactoryGirl.define do
  factory :fixture do
    home_club
    away_club
    datetime { Date.tomorrow }
  end
end
