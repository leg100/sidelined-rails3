class InjuryArraySerializer < EventArraySerializer
  attributes :source, :return_date, :quote, :status, :body_part

  has_one :player
  def template_url
    "/views/widgets/injury.html"
  end
end
