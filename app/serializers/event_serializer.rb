class EventSerializer < ActiveModel::Serializer
  attributes :id, :version, :_type, :template_url, :edit_template_url, :updated_at
  has_one :modifier
  has_many :revisions

  def revisions
    HistoryTracker.where(:association_chain.elem_match => {id: id})
      .includes(:modifier).desc(:version)
  end

  def template_url
    "/templates/widgets/event.tmpl"
  end
  def edit_template_url
    "/templates/widgets/event.edit.tmpl"
  end
end
