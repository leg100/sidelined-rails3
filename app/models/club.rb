class Club
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::History::Trackable

  track_history   :on => :all,
                  :modifier_field => :modifier,
                  :modifier_field_inverse_of => :nil,
                  :version_field => :version,
                  :track_create   =>  false,
                  :track_update   =>  true,
                  :track_destroy  =>  false

  has_many :players
  has_many :home_fixtures, class_name: 'Fixture', inverse_of: :home_club
  has_many :away_fixtures, class_name: 'Fixture', inverse_of: :away_club

  field :long_name, type: String
  field :short_name, type: String
  
  alias :name :short_name

  def self.sort_by_ticker
    Club.all.sort_by{|c| c.short_name }
  end

  def fixtures
    home_fixtures + away_fixtures 
  end
end
