class InjurySerializer < EventSerializer
  attributes :source, :return_date, :quote, :status, :body_part
  has_one :player

  def template_url
    "/views/widgets/injury.html"
  end

  def edit_template_url
    "/views/widgets/injury.edit.html"
  end
end
