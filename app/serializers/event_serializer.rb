class EventSerializer < ActiveModel::Serializer
  attributes :id, :version, :_type, :updated_at
  has_one :modifier

  has_many :revisions, serializer: HistoryTrackerSerializer
  def revisions
    HistoryTracker.includes(:modifier).where(:association_chain.elem_match => {id: id})
      .desc(:version)
  end
end
