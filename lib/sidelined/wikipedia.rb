require 'httparty'
require 'json'

module Sidelined
  class Wikipedia
    include HTTParty
    base_uri 'en.wikipedia.org'

    attr_accessor :options
    attr_accessor :cmcontinue
    
    def initialize; 
      @options = {
        query: {
          action: 'query',
          format: "json"
        }
      }
      @cmcontinue = nil
    end

    def get_player_page(id_or_title)
      if id_or_title.is_a?(Integer)      
        options[:query].merge!({ pageids: id_or_title })
      end
      if id_or_title.is_a?(String)       
        options[:query].merge!({ titles: id_or_title })
      end

      options[:query].merge!({
        prop: 'revisions',
        rvprop: 'content'
      })

      resp = call_wiki_api
      resp["query"]["pages"].first
    end

    def get_all_cat_pages()
      results = []
      options[:query].merge!({
          list: 'categorymembers',
          cmtitle: "Category:Premier_League_players",
          cmlimit: 500,
      })

      loop do
        body = call_wiki_api
        results = results + body['query']['categorymembers']

        if body.key?('query-continue') and 
          body['query-continue'].key?('categorymembers') and
          body['query-continue']['categorymembers'].key?('cmcontinue')
          
          cmcontinue = body['query-continue']['categorymembers']['cmcontinue']
          options[:query].merge!({:cmcontinue => cmcontinue})
        else
          results.reject!{|r| r['title'] =~ /^List of/ }
          results.reject!{|r| r['title'] =~ /^Category:/ }
          return results
        end
      end
    end

private
    def call_wiki_api()
      resp = self.class.get('/w/api.php', options)
      if resp.code == 200
         return JSON.parse(resp.body)
      else
         raise Exception => resp.message
      end
    end
  end
end
