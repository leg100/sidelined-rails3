class EventSerializer < ActiveModel::Serializer
  attributes :id, :version, :_type, :template_url
  has_one :modifier

  def template_url
    "/templates/events/event.tmpl"
  end
end
