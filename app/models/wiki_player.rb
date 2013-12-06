class WikiPlayer
  include Mongoid::Document
  store_in collection: "players", session: "wikipedia"
  embeds_one :infobox
  default_scope exists('infobox.currentclub' => true)

  field :pageid, type: Integer
  field :title, type: String
  
  def name
    @name ||= ::PlayerName.new(title)
  end

  def wiki_team
    components = WikiPlayer.parse_wiki_link(infobox.currentclub)
    components.empty? ? nil : components[1]
  end
 
  def premier_league?
    PREMIER_LEAGUE_TEAMS.include?(wiki_team)
  end

  def self.parse_wiki_link(text)
    # [[Milton Keynes Dons F.C.|Milton Keynes Dons]]<br>(First-Team Coach)
    # return [link,text]
    /\[\[([^\|\]]+)\|?([^\]]+)?\]\]/.match(text.to_s).to_a.compact
  end

  PREMIER_LEAGUE_TEAMS = [
    "Arsenal F.C.",
    "Manchester United F.C.",
    "Southampton F.C.",
    "Newcastle United F.C.",
    "Aston Villa F.C.",
    "Chelsea F.C.",
    "Tottenham Hotspur F.C.",
    "Crystal Palace F.C.",
    "Stoke City F.C.",
    "Manchester City F.C.",
    "West Ham United F.C.",
    "Fulham F.C.",
    "Cardiff City F.C.",
    "Swansea City A.F.C.",
    "Norwich City F.C.",
    "Hull City A.F.C.",
    "Everton F.C.",
    "West Bromwich Albion F.C.",
    "Sunderland A.F.C.",
    "Liverpool F.C."
  ]
end

class Infobox
  include Mongoid::Document
  store_in session: "wikipedia"
  embedded_in :player

  field :currentclub, type: String
end
