class InjurySerializer < EventSerializer
  attributes :source, :return_date
  has_one :player

  def template_url
    "/templates/widgets/injury.tmpl"
  end

  def edit_template_url
    "/templates/widgets/injury.edit.tmpl"
  end
end
