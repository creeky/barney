#!/usr/bin/ruby
# Script zum Scrapen der Wetten von bet365.com

require 'helpers/urltools.rb'
require 'helpers/analysequery.rb'

class Bet365Scraper
	def initialize(sports)
		@sports = sports
		@sporturls = {
# Meiner Meinung nach sollten die Sportarten nach Ligen unterteilt werden
			'Baseball/MLB' => 'http://www.bet365.com/home/mainpage.asp'
		}

# Sportart: hunderter, Ligen: fortlaufende Nummer
# Die IDs kann man vielleicht besser in ein helper-script auslagern...
		@sportids = {
			'Baseball/MLB' => 101,
			'Basketball/NBA' => 201,
			'Football/NFL' => 301,

			'Baseball' => 100
		}
		@reg_expr = {
			'Baseball/MLB' => /<tr class="rh1">.+?<td [^>]+>.+?<\/td>.+?<td [^>]+>.+?<\/td>.+?<td [^>]+>([^&]+)&nbsp;<br>.+?<\/td>.+?<td [^>]+>.+?<\/td>.+?<td [^>]+>(\d{1,2}.\d{2})<\/td>.+?<td [^>]+>.+?<\/td>.+?<td [^>]+>.+?<\/td>.+?<td [^>]+>.+?<\/td>.+?<td [^>]+>.+?<\/td>.+?<td [^>]+>.+?<\/td><\/tr>.+?<tr class="c1 rh1">.+?<td [^>]+>.+?<\/td>.+?<td [^>]+>([^<]+)<br>.+?<\/td>.+?<td [^>]+>(\d{1,2}.\d{2})<\/td>/m
		}
		@games = {}
		@teams = {
#			"Arizona Diamondbacks"=>"Arizona D-Backs",
			"ATL Braves"=>"Atlanta Braves",
#			"Baltimore Orioles"=>"Baltimore Orioles",
			"BOS Red Sox"=>"Boston Red Sox",
			"CHI Cubs"=>"Chicago Cubs",
			"CIN Reds"=>"Cincinnati Reds",
#			"Cleveland Indians"=>"Cleveland Indians",
			"COL Rockies"=>"Colorado Rockies",
			"CHI White Sox"=>"Chicago White Sox",
			"DET Tigers"=>"Detroit Tigers",
			"FLA Marlins"=>"Florida Marlins",
			"HOU Astros"=>"Houston Astros",
#			"Kansas City Royals"=>"Kansas City Royals",
			"LA Angels"=>"LAA Angels",
			"LA Dodgers"=>"Los Angeles Dodgers",
			"MIL Brewers"=>"Milwaukee Brewers",
			"MIN Twins"=>"Minnesota Twins",
			"NY Mets"=>"New York Mets",
			"NY Yankees"=>"New York Yankees",
#			"Oakland Athletics"=>"Oakland Athletics",
			"PHI Phillies"=>"Philadelphia Phillies",
			"PIT Pirates"=>"Pittsburgh Pirates",
			"SD Padres"=>"San Diego Padres",
			"SEA Mariners"=>"Seattle Mariners",
			"SF Giants"=>"San Francisco Giants",
			"STL Cardinals"=>"St Louis Cardinals",
			"TB Rays"=>"Tampa Bay Rays",
			"TEX Rangers"=>"Texas Rangers",
#			"Toronto Bluejays"=>"Toronto Blue Jays",
			"WAS Nationals"=>"Washington Nationals"
		}
	end

	def get_odds

		  headers = {
				"Cookie" => "aps03=lng=5&cf=N"
		  }

			$postq = {
 				"txtNavigationPB" => {},
	 			"txtSiteNavigationPB" => {
 				  "dummy" => "0"
				 },
 				"txtSiteNavigationCachePB" => {},
				"txtClassID" => "16",
				"txtNPID" => "100000",
				"txtSiteNavigationPB" => {
					"c1id" => "20153629",
					"c1idtable" => "48",
					"c2id" => "1",
					"c2idtable" => "36"
				}			
			}

		@sports.each do |name|
			puts("Hole #{name}-Daten von Bet365")
			$stdout.flush
			text = ""

			out = reform_query($postq)
			post_request(@sporturls[name], out, headers) { |string|
				text = text + string
			}

#		File.open("junk.html", "w") { |file|
#		file.write(text)
#		file.close }

#game: team1, odd1, team2, odd2
			@games[name] = text.scan(@reg_expr[name])
			if(text == "")
				puts("Es konnten keine Daten gefunden werden")
				$stdout.flush
			end
		end
	end

	def write_to_file(filename="output/bet365.xml")
		puts("Schreibe Daten in #{filename}")
		File.open(filename, "w") { |file|
			file.puts("<bookmaker name=\"Bet365\">")
			@sports.each do |sport|
				file.puts("<sport name=\"#{sport}\" id=\"#{@sportids[sport]}\">")
				@games[sport].each do |game|
# Wie soll sich die GameID berechnen?
					file.puts("<game id=\"1\">")

# Das Datum sollte umgerechnet werden (zB in yyyymmddhh)
					file.puts("<date>", "N/A", "</date>")
					file.puts("<time>", "N/A", "</time>")

					file.puts("<team1 id=\"N/A\">", @teams[game[0].strip], "</team1>")
					file.puts("<odd1>", game[1], "</odd1>")
					file.puts("<team2 id=\"N/A\">", @teams[game[2].strip], "</team2>")
					file.puts("<odd2>", game[3], "</odd2>")

					file.puts("</game>")
				end
				file.puts("</sport>")
			end
			file.puts("</bookmaker>")
			file.close()
		}
		puts("Fertig")
		$stdout.flush
	end
end

#nur wenn das Script direkt gestartet wird, wird dieser Teil ausgeführt
if __FILE__ == $0

sports = ['Baseball/MLB']
ps = Bet365Scraper.new(sports)
ps.get_odds()
ps.write_to_file()

end
