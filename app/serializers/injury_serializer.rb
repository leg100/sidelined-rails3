class InjurySerializer < EventSerializer
  attributes :source, :return_date
  has_one :player

  def template_url
    "/templates/events/injury.tmpl"
  end
end
