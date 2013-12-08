FactoryGirl.define do
  factory :injury do
    player
    source 'http://www.thesun.com/injury-article'
    return_date { Date.tomorrow }
  end
end
