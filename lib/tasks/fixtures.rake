require './lib/sidelined/rest_client.rb'

namespace :fixtures do
  desc "Create fixtures for 2013/2014 PL season"
  task :create do
    clubs = Sidelined::RestClient::Club.get()
    clubs_mapping = clubs.inject({}){|h,c| 
      k = c['short_name']; v = c['_id']
      h[k] = v
      h
    }

    Dir.glob("./db/fixtures/*.json").each {|ffile|

      fixture = JSON.parse(open(ffile, 'r').read)
      fixture["home_club"] = clubs_mapping[fixture["home_club"]]
      fixture["away_club"] = clubs_mapping[fixture["away_club"]]

      puts "creating #{fixture.inspect}" 
      resp = Sidelined::RestClient::Fixture.post(fixture)
      if resp.code == 201
         puts "successfully created /fixtures/#{resp.body}"
      else
         STDERR.puts resp.message
      end
    }
  end
end
