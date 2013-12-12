class Player
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::History::Trackable
  include Mongoid::Slug

  belongs_to :club
  accepts_nested_attributes_for :club

  track_history   :on => :all,
                  :modifier_field => :modifier,
                  :modifier_field_inverse_of => :nil,
                  :version_field => :version,
                  :track_create   =>  false,
                  :track_update   =>  true,
                  :track_destroy  =>  false

  field :short_name, type: String
  field :long_name, type: String
  field :forename, type: String
  field :surname, type: String
  field :forenames, type: Array
  field :surnames, type: Array
  field :wiki_team, type: String
  slug :long_name, history: true

  validates_length_of :short_name, minimum: 2, maximum: 4
  validates_presence_of :long_name
  validates_uniqueness_of :long_name

  def as_json(options={})
    super(options.merge(:include => [:club]))
  end

  def tokens
    [forenames, surnames, short_name].flatten.map(&:parameterize)
  end
end
