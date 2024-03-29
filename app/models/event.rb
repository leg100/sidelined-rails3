# how to handle inter-related events?

class Event
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::History::Trackable
  include ActiveModel::ForbiddenAttributesProtection

  track_history   :on => :all,
                  :modifier_field => :modifier,
                  :modifier_field_inverse_of => :events,
                  :version_field => :version,
                  :track_create   =>  true,
                  :track_update   =>  true,
                  :track_destroy  =>  true

  belongs_to :player

end

class Fixture < Event
  belongs_to :home_club, :class_name => 'Club', inverse_of: :home_fixture
  belongs_to :away_club, :class_name => 'Club', inverse_of: :away_fixture

  field :datetime, type: DateTime

  validates_presence_of :home_club
  validates_associated :home_club
  validates_presence_of :away_club
  validates_associated :away_club
  validates_presence_of :datetime
  validates_uniqueness_of :home_club, :scope => :away_club
  validate :club_cannot_play_itself

  def club_cannot_play_itself
    if home_club === away_club
      errors.add(:home_club, "cannot play itself")
    end
  end

  def clubs
    home_club + away_club
  end
end

class Injury < Event
  field :source, type: String
  field :quote, type: String
  field :return_date, type: Date
  field :status, type: String
  field :body_part, type: String

  validate :return_date_cannot_be_in_the_past
  validate :source_must_be_url_if_present
  validates :status, :inclusion => { :in => %w[doubtful injured recovered] }
  validates_presence_of :player
  validates_associated :player

  def source_must_be_url_if_present
    if source.present? && source !~ /^(http|https)/
      errors.add(:source, "must be be a valid URL")
    end
  end

  def return_date_cannot_be_in_the_past
    if status != 'recovered' && return_date.present? &&
      return_date < Date.today
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
  validates_format_of :source, :with => URI::regexp(%w(http https))
end
