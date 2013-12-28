class FixtureSerializer < EventSerializer
  has_one :home_club
  has_one :away_club

  def template_url
    "/templates/events/fixture.tmpl"
  end
end
