class User
  include Mongoid::Document

  has_many :events
  validates_uniqueness_of :username
  # email validation is provided by devise

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :email, :password, :password_confirmation, :remember_me

  # Virtual attribute for authenticating by either username or email
  # # This is in addition to a real persisted field like 'username'
  attr_accessor :login
  attr_accessible :login

  ## Database authenticatable
  field :username,           :type => String, :default => ""
  field :email,              :type => String, :default => ""
  field :encrypted_password, :type => String, :default => ""

  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  ## Confirmable
  field :confirmation_token,   :type => String
  field :confirmed_at,         :type => Time
  field :confirmation_sent_at, :type => Time
  # field :unconfirmed_email,    :type => String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  # field :locked_at,       :type => Time
# function to handle user's login via email or username

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login).downcase
      where(conditions).where(
        '$or' => [ 
          {:username => /^#{Regexp.escape(login)}$/i}, 
          {:email => /^#{Regexp.escape(login)}$/i} ]
      ).first
    else
      where(conditions).first
    end
  end 
end
