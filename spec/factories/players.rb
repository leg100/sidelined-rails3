FactoryGirl.define do
  factory :player do
    club
    short_name "MLT"
    long_name "Matt Le Tissier"
    forename "Matt"
    surname "Le Tissier"
    forenames %w[Matt] 
    surnames %w[Le Tissier]
  end
end
