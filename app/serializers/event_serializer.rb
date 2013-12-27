class EventSerializer < ActiveModel::Serializer
  attributes :version, :_type, :template_url
  has_one :modifier

  def template_url
    "/templates/event.tmpl"
  end
end
