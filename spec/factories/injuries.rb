FactoryGirl.define do
  factory :injury do
    player
    source 'http://www.thesun.com/injury-article'
    status { %w[confirmed recovered doubt].sample }
    return_date { Date.tomorrow }
  end
end
