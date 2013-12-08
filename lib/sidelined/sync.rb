module Sidelined
  module Sync
    def self.sync_with_wiki_db
      WikiPlayer.all.select{|wp| wp.premier_league? }.each {|wp|
        existing = Player.where(long_name: wp.name.to_s).first
        if existing
          existing.update_attributes(
            short_name: wp.name.trkref,
            long_name: wp.name.to_s,
            surname: wp.name.surname,
            forename: wp.name.forename,
            surnames: wp.name.surname_tokens,
            forenames: wp.name.forename_tokens,
            wiki_team: wp.wiki_team
          )
        else
          player = Player.new(
            short_name: wp.name.trkref,
            long_name: wp.name.to_s,
            surname: wp.name.surname,
            forename: wp.name.forename,
            surnames: wp.name.surname_tokens,
            forenames: wp.name.forename_tokens,
            wiki_team: wp.wiki_team
          )
          player.save
        end
      }
    end
  end
end
