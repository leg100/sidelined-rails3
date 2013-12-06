class Event
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::History::Trackable

  track_history   :on => :all,
                  :modifier_field => :modifier,
                  :modifier_field_inverse_of => :nil,
                  :version_field => :version,
                  :track_create   =>  true,
                  :track_update   =>  true,
                  :track_destroy  =>  true
end

class FixtureEvent < Event
  belongs_to :home_club, :class_name => 'Club', inverse_of: :home_fixture
  belongs_to :away_club, :class_name => 'Club', inverse_of: :away_fixture

  field :datetime, type: DateTime
end
