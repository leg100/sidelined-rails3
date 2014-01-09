class HistoryTrackerSerializer < ActiveModel::Serializer
  attributes :id, :association_chain, :scope, :original, :updated_at, :created_at, :version, :action
  has_one :modifier
end
