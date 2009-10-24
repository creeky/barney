#!/usr/bin/ruby
# Script zum Scrapen der Wetten von bet-at-home.com

require 'helpers/urltools.rb'

class BetathomeScraper
	def initialize(sports)
		@sports = sports
		@sporturls = {
# Meiner Meinung nach sollten die Sportarten nach Ligen unterteilt werden
			'Baseball/MLB' => 'http://bet-at-home.com/odd.aspx?action=toggleEventGroup&SportID=7&EventGroupID=1',
			'Football/NFL' => 'http://bet-at-home.com/odd.aspx?action=toggleEventGroup&SportID=6&EventGroupID=97'
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
			'Football/NFL' => /<tr class="OT_R[^>]+>.+?<td[^>]+>[^<]+<\/td>[^<]+<td[^>]+>([^-]+) - ([^<]+)<a [^>]+>.+?<td[^>]+>[^<]+<\/td>.+?<td[^>]+>.+?(\d{1,2},\d{2}).+?<\/td>.+?<td[^>]+>.+?(\d{1,2},\d{2}).+?<\/td>/m,
			# identisch mit Football/NFL
			'Baseball/MLB' => /<tr class="OT_R[^>]+>.+?<td[^>]+>[^<]+<\/td>[^<]+<td[^>]+>([^-]+) - ([^<]+)<a [^>]+>.+?<td[^>]+>[^<]+<\/td>.+?<td[^>]+>.+?(\d{1,2},\d{2}).+?<\/td>.+?<td[^>]+>.+?(\d{1,2},\d{2}).+?<\/td>/m
		}
		@games = {}
		@teams = {
			#Baseball/MLB
			"Los Angeles Angels"=>"LAA Angels",
			"New York Yankees"=>"New York Yankees",

			#Football/NFL
			# gecheckt
			"Buffalo Bills"=>"Buffalo Bills",
			"New England Patriots"=>"New England Patriots",
			"San Diego Chargers"=>"San Diego Chargers",
			"Oakland Raiders"=>"Oakland Raiders",
			"Pittsburgh Steelers"=>"Pittsburgh Steelers",
			"Minnesota Vikings"=>"Minnesota Vikings",
			"St. Louis Rams"=>"St Louis Rams",
			"Indianapolis Colts"=>"Indianapolis Colts",
			"Kansas City Chiefs"=>"Kansas City Chiefs",
			"Tampa Bay Buccaneers"=>"Tampa Bay Buccaneers",
			"New York Jets"=>"New York Jets",
			"Miami Dolphins"=>"Miami Dolphins",
			"New Orleans Saints"=>"New Orleans Saints",
			"Cincinnati Bengals"=>"Cincinnati Bengals",
			"Chicago Bears"=>"Chicago Bears",
			"Dallas Cowboys"=>"Dallas Cowboys",
			"Atlanta Falcons"=>"Atlanta Falcons",
			"Carolina Panthers"=>"Carolina Panthers",
			"New York Giants"=>"New York Giants",
			"Arizona Cardinals"=>"Arizona Cardinals",
			"Washington Redskins"=>"Washington Redskins",
			"Philadelphia Eagles"=>"Philadelphia Eagles",
			"San Francisco 49ers"=>"San Francisco 49ers",
			"Houston Texans"=>"Houston Texans",
			"Cleveland Browns"=>"Cleveland Browns",
			"Green Bay Packers"=>"Green Bay Packers"			
		}
	end

	def get_odds

		headers = {}

		@sports.each do |name|
			puts("Hole #{name}-Daten von Bet-at-Home")
			$stdout.flush
			text = ""
			get_request(@sporturls[name], headers) { |string|
				text = text + string
			}

#game: team1, team2, odd1, odd2
			@games[name] = text.scan(@reg_expr[name])
			if(text == "")
				puts("Es konnten keine Daten gefunden werden")
				$stdout.flush
			end
		end
	end

	def write_to_file(filename="output/bet-at-home.xml")
		puts("Schreibe Daten in #{filename}")
		File.open(filename, "w") { |file|
			file.puts("<bookmaker name=\"Bet-at-Home\">")
			@sports.each do |sport|
				file.puts("<sport name=\"#{sport}\" id=\"#{@sportids[sport]}\">")
				@games[sport].each do |game|
# Wie soll sich die GameID berechnen?
					file.puts("<game id=\"1\">")

# Das Datum sollte umgerechnet werden (zB in yyyymmddhh)
					file.puts("<date>", "N/A", "</date>")
					file.puts("<time>", "N/A", "</time>")

					file.puts("<team1 id=\"N/A\">", @teams[game[0].strip], "</team1>")
					file.puts("<odd1>", game[2].strip, "</odd1>")
					file.puts("<team2 id=\"N/A\">", @teams[game[1].strip], "</team2>")
					file.puts("<odd2>", game[3].strip, "</odd2>")

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

sports = ['Baseball/MLB', 'Football/NFL']
ps = BetathomeScraper.new(sports)
ps.get_odds()
ps.write_to_file()

end
