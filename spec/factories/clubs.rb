FactoryGirl.define do
  factory :club, aliases: [:from_club, :to_club, :home_club, :away_club] do
    short_name { Faker::Base.regexify(/^[A-Z]{3}$/) } 
    long_name { Faker::Name.name }
  end
end

