Mongoid::History.tracker_class_name = :history_tracker
Mongoid::History.current_user_method = :current_user

# in development mode rails does not load all models/classes
#  # force rails to load history tracker class
Rails.env == 'development' and require_dependency(Mongoid::History.tracker_class_name.to_s)
