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

  field :long_name, type: String
  field :short_name, type: String
  
  alias :name :short_name
end
