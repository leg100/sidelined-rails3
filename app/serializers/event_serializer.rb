class EventSerializer < ActiveModel::Serializer
  attributes :id, :version, :_type, :template_url, :edit_template_url, :revisions, :updated_at
  has_one :modifier

  def template_url
    "/templates/widgets/event.tmpl"
  end
  def edit_template_url
    "/templates/widgets/event.edit.tmpl"
  end
end
