FactoryGirl.define do
  factory :injury do
    player
    source 'http://www.thesun.com/injury-article'
    status { %w[injured recovered doubtful].sample }
    body_part 'Arse'
    return_date { Date.tomorrow }
  end
end
