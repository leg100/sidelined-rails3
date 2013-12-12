require './lib/sidelined/wikipedia.rb'
require './lib/sidelined/infobox.rb'
require './lib/sidelined/rest_client.rb'
require './lib/sidelined/player-name.rb'

namespace :wikipedia do
  desc "Download player page ID's from wikipedia"
  task :cat_pages do
    FileUtils.mkdir_p('./db/wikipedia')

    w = Sidelined::Wikipedia.new
    pages = w.get_all_cat_pages()
    
    File.open('./db/wikipedia/wiki_cat_pages.json', 'w') do |f|
      f.puts JSON.pretty_generate(pages)
    end
  end

  desc "Download player pages from wikipedia" 
  task :player_pages do
    w = Sidelined::Wikipedia.new

    FileUtils.mkdir_p('./db/wikipedia/players')
    pages = JSON.parse(open('./db/wikipedia/wiki_cat_pages.json', 'r').read)
    pages.each {|p|
      title = p['title'].gsub(/ /, '_')
      puts "fetching #{title}"
      content = w.get_player_page(p['pageid'])
    
      File.open("./db/wikipedia/players/#{title}.json", 'w') do |f|
        f.puts JSON.pretty_generate(content)
      end
    }
  end

  desc "Parse player infobox"
  task :infoboxes do
    infobox_re = /^ ?\| *(\w+)\s+= (.*)$/
    infobox_start_re = /^{{Infobox football biography$/
    infobox_end_re = /^}}$/

    FileUtils.mkdir_p('./db/wikipedia/infoboxes')

    Dir.glob("./db/wikipedia/players/*.json").each {|p|

      player = JSON.parse(open(p, 'r').read)
      content = player[1]['revisions'][0]['*']
      pageid = player[1]['pageid']
      title = player[1]['title'].gsub(/ /, '_')

      # find first line of infobox
      line_num = 0
      content.split("\n").each_with_index {|line, i|      
        if line =~ infobox_start_re
          puts "infobox found at line num #{i}"
          line_num = i
          break
        end
      }

      output = {
        infobox: {},
        pageid: pageid,
        title: title
      }
      content.split("\n")[line_num..-1].each {|line|
        break if line =~ infobox_end_re
        
        if line =~ infobox_re
          output[:infobox][$1] = $2
        end
      }
    
      File.open("./db/wikipedia/infoboxes/#{title}.json", 'w') do |f|
        f.puts JSON.pretty_generate(output)
      end
    }
  end

  desc "Create player records from infoboxes"
  task :player_rows do
    clubs = Sidelined::RestClient::Club.get()
    clubs_mapping = clubs.inject({}){|h,c| 
      k = c['long_name']; v = c['_id']
      h[k] = v
      h
    }

    Dir.glob("./db/wikipedia/infoboxes/*.json").each {|p|

      player = JSON.parse(open(p, 'r').read)
      infobox = Sidelined::Infobox.new(player)
      club_id = clubs_mapping[infobox.wiki_team]

      next unless infobox.premier_league?

      resp = Sidelined::RestClient::Player.post({
          short_name: infobox.name.trkref,
          long_name: infobox.name.to_s,
          forename: infobox.name.forename,
          surname: infobox.name.surname,
          forenames: infobox.name.forename_tokens,
          surnames: infobox.name.surname_tokens,
          club: club_id
        }
      )
      if resp.code == 201
         puts "successfully created /players/#{infobox.name.to_s}"
      else
         STDERR.puts resp.message
      end
    }
  end
end
