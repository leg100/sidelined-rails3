class HistoryTrackerSerializer < ActiveModel::Serializer
  attributes :id, :action, :association_chain, :scope, :modified, :original, :updated_at, :created_at, :version
  has_one :modifier
end
