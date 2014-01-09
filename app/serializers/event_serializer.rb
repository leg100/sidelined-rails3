class EventSerializer < ActiveModel::Serializer
  attributes :id, :version, :_type, :template_url, :edit_template_url, :updated_at
  has_one :modifier
  has_many :revisions, serializer: HistoryTrackerSerializer

  def revisions
    HistoryTracker.includes(:modifier).where(:association_chain.elem_match => {id: id})
      .desc(:version)
  end

  def template_url
    "/templates/widgets/event.tmpl"
  end
  def edit_template_url
    "/templates/widgets/event.edit.tmpl"
  end
end
