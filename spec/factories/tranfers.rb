FactoryGirl.define do
  factory :transfer do
    player
    from_club
    to_club
    status "rumour"
    source 'http://www.thesun.com/transfer-article'
  end
end

