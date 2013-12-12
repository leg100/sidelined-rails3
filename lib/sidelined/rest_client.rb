require 'httparty'
require 'json'

module Sidelined
  class RestClient
    include HTTParty
    #base_uri 'sidelined.herokuapp.com'
    base_uri 'sidelined.local'

    attr_accessor :options
    WIKI_USER = 'wikipedia'
    WIKI_PASS = 'j843874q'

    class Fixture
      def self.post(fixture)
        options = {:body => {:fixture => fixture}.to_json}
        options.merge!(:basic_auth => {:username => WIKI_USER, :password => WIKI_PASS})
        options.merge!(:headers => { 'Content-Type' => 'application/json' })

        Sidelined::RestClient.post("/fixtures.json", options)
      end
    end

     class Player
      def self.get(slug='')
        Sidelined::RestClient.get("/players/#{slug}")
      end
      def self.post(player)
        options = {:body => {:player => player}.to_json}
        options.merge!(:basic_auth => {:username => WIKI_USER, :password => WIKI_PASS})
        options.merge!(:headers => { 'Content-Type' => 'application/json' })

        Sidelined::RestClient.post("/players.json", options)
      end
      def self.put(slug, player)
        options = {:body => player}
        Sidelined::RestClient.put("/players/#{slug}", options)
      end
    end

    class Club
      def self.get(id=nil)
        uri = id.nil? ? "/clubs.json" : "/clubs/#{id}.json"
        resp = Sidelined::RestClient.get(uri)
        JSON.parse(resp.body)
      end
      def self.post(club); end
      def self.put(club); end
    end
  end
end
