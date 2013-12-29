class InjurySerializer < EventSerializer
  attributes :source, :return_date
  has_one :player

  def template_url
    "/templates/events/injury.tmpl"
  end

  def edit_template_url
    "/templates/events/injury.edit.tmpl"
  end
end
