class EventSerializer < ActiveModel::Serializer
  attributes :id, :version, :_type, :template_url, :edit_template_url
  has_one :modifier

  def template_url
    "/templates/events/event.tmpl"
  end
  def edit_template_url
    "/templates/events/event.edit.tmpl"
  end
end
