# how to handle inter-related events?

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

class Fixture < Event
  belongs_to :home_club, :class_name => 'Club', inverse_of: :home_fixture
  belongs_to :away_club, :class_name => 'Club', inverse_of: :away_fixture

  field :datetime, type: DateTime

  def clubs
    home_club + away_club
  end
end

class Injury < Event
  belongs_to :player

  field :source, type: String
  field :return_date, type: Date

  validate :return_date_cannot_be_in_the_past

  def return_date_cannot_be_in_the_past
    if return_date.present? && return_date < Date.today
      errors.add(:return_date, "can't be in the past")
    end
  end
end

class Transfer < Event
  belongs_to :player
  belongs_to :from_club, :class_name => 'Club', inverse_of: :outgoing_transfers
  belongs_to :to_club, :class_name => 'Club', inverse_of: :incoming_transfers

  field :status, type: String
  field :source, type: String

  validates_inclusion_of :status, :in => %w[rumour confirmed complete did_not_happen]
end
