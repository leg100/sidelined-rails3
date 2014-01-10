require 'httparty'
require 'json'

module Sidelined
  class RestClient
    include HTTParty
    #base_uri 'sidelined.herokuapp.com'
    base_uri 'sidelined.local'

    WIKI_USER = 'wikipedia'
    WIKI_PASS = 'j843874q'

    def initialize
      options = {body: { user: { login: WIKI_USER, password: WIKI_PASS } } }
      resp = HTTParty.post('http://sidelined.local/api/login', options)
      parsed_resp = JSON.parse(resp.body)

      unless parsed_resp.key?('success') and parsed_resp['success']
        raise "Could not login"
      end

      @options = {
        headers: {
          'Content-Type' => 'application/json',
          'Cookie' => resp.headers['set-cookie']
        }
      }
    end

    class Fixture
      def self.post(fixture)
        @options.merge!({:body => {:fixture => fixture}.to_json})
        HTTParty.post("/fixtures.json", @options)
      end
    end

    class Player
      def self.get(slug='')
        HTTParty.get("/players/#{slug}", @options)
      end

      def self.post(player)
        @options.merge!({:body => {:player => player}.to_json})

        HTTParty.post("/players.json", @options)
      end

      def self.put(slug, player)
        @options.merge!({:body => {:player => player}.to_json})
        HTTParty.put("/players/#{slug}", @options)
      end
    end

    class Club
      def self.get(id=nil)
        uri = id.nil? ? "/clubs.json" : "/clubs/#{id}.json"
        resp = HTTParty.get(uri)
        JSON.parse(resp.body)
      end
      def self.post(club); end
      def self.put(club); end
    end
  end
end
