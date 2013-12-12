require './lib/sidelined/player-name.rb'

module Sidelined
  class Infobox
    attr_reader :infobox
    attr_reader :name

    def initialize(infobox)
      @infobox = infobox['infobox']
      @name = PlayerName.new(infobox['title'])
    end

    def wiki_team
      return nil unless infobox.key?('currentclub')
      components = self.class.parse_wiki_link(infobox['currentclub'])
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
end

