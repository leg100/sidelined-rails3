class EventArraySerializer < ActiveModel::Serializer
  attributes :id, :_type, :template_url, :updated_at
  has_one :modifier

  def template_url
    "/templates/widgets/event.tmpl"
  end
end
