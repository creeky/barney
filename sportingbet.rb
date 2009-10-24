#!/usr/bin/ruby
# Script zum Scrapen der Wetten von sportingbet.com

require 'helpers/urltools.rb'

class SportingbetScraper
	def initialize(sports)
		@sports = sports
		@sporturls = {
# Meiner Meinung nach sollten die Sportarten nach Ligen unterteilt werden
			'Baseball/MLB' => 'http://de.sportingbet.com/Baseball;Baseball-Spiele;-Aktuelle-Spiele-/ECMARKET/9/77263/9?',
			'Football/NFL' => 'http://de.sportingbet.com/Am--Football;NFL---Woche-1---Spiele;-Aktuelle-Spiele-/ECMARKET/10/159426/10?'
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
			'Baseball/MLB' => /<tr [^>]+>[^<]+<td [^>]+>[^<]+<span [^>]+>([^<]+)<\/span>[^<]+<span [^>]+>([^<]+)<\/span>[^<]+<\/td>[^<]+<td [^>]+>.+?<\/td>[^<]+<td [^>]+>.+?<\/td>[^<]+<td [^>]+>[^<]+<a [^>]+>(\d{1,3}.\d{2,3}).+?<a [^>]+>(\d{1,3}.\d{2,3})/m,
			'Football/NFL' => /<tr [^>]+>[^<]+<td [^>]+>[^<]+<span [^>]+>([^<]+)<\/span>[^<]+<span [^>]+>([^<]+)<\/span>[^<]+<\/td>[^<]+<td [^>]+>.+?<\/td>[^<]+<td [^>]+>.+?<\/td>[^<]+<td [^>]+>[^<]+<a [^>]+>(\d{1,3}.\d{2,3}).+?<a [^>]+>(\d{1,3}.\d{2,3})/m
		}
		@games = {}
		@teams = {
			#Baseball/MLB
			"Arizona Diamondbacks"=>"Arizona D-Backs",
			"Atlanta Braves"=>"Atlanta Braves",
			"Baltimore Orioles"=>"Baltimore Orioles",
			"Boston Red Sox"=>"Boston Red Sox",
			"Chicago Cubs"=>"Chicago Cubs",
			"Cincinnati Reds"=>"Cincinnati Reds",
			"Cleveland Indians"=>"Cleveland Indians",
			"Colorado Rockies"=>"Colorado Rockies",
			"Chicago White Sox"=>"Chicago White Sox",
			"Detroit Tigers"=>"Detroit Tigers",
			"Florida Marlins"=>"Florida Marlins",
			"Houston Astros"=>"Houston Astros",
			"Kansas City Royals"=>"Kansas City Royals",
			"Los Angeles Angels"=>"LAA Angels",
			"Los Angeles Dodgers"=>"Los Angeles Dodgers",
			"Milwaukee Brewers"=>"Milwaukee Brewers",
			"Minnesota Twins"=>"Minnesota Twins",
			"New York Mets"=>"New York Mets",
			"New York Yankees"=>"New York Yankees",
			"Oakland Athletics"=>"Oakland Athletics",
			"Philadelphia Phillies"=>"Philadelphia Phillies",
			"Pittsburgh Pirates"=>"Pittsburgh Pirates",
			"San Diego Padres"=>"San Diego Padres",
			"Seattle Mariners"=>"Seattle Mariners",
			"San Francisco Giants"=>"San Francisco Giants",
			"St. Louis Cardinals"=>"St Louis Cardinals",
			"Tampa Bay Rays"=>"Tampa Bay Rays",
			"Texas Rangers"=>"Texas Rangers",
			"Toronto Blue Jays"=>"Toronto Blue Jays",
			"Washington Nationals"=>"Washington Nationals",

			#Football/NFL
			# wurden alle gecheckt!
			"Green Bay Packers"=>"Green Bay Packers",
			"Cleveland Browns"=>"Cleveland Browns",
			"Indianapolis Colts"=>"Indianapolis Colts",
			"St. Louis Rams"=>"St Louis Rams",
			"Minnesota Vikings"=>"Minnesota Vikings",
			"Pittsburgh Steelers"=>"Pittsburgh Steelers",
			"New England Patriots"=>"New England Patriots",
			"Tampa Bay Buccaneers"=>"Tampa Bay Buccaneers",
			"San Diego Chargers"=>"San Diego Chargers",
			"Kansas City Chiefs"=>"Kansas City Chiefs",
			"San Francisco 49ers"=>"San Francisco 49ers",
			"Houston Texans"=>"Houston Texans",
			"Buffalo Bills"=>"Buffalo Bills",
			"Carolina Panthers"=>"Carolina Panthers",
			"New York Jets"=>"New York Jets",
			"Oakland Raiders"=>"Oakland Raiders",
			"Atlanta Falcons"=>"Atlanta Falcons",
			"Dallas Cowboys"=>"Dallas Cowboys",
			"Chicago Bears"=>"Chicago Bears",
			"Cincinnati Bengals"=>"Cincinnati Bengals",
			"New Orleans Saints"=>"New Orleans Saints",
			"Miami Dolphins"=>"Miami Dolphins",
			"Arizona Cardinals"=>"Arizona Cardinals",
			"New York Giants"=>"New York Giants",
			"Philadelphia Eagles"=>"Philadelphia Eagles",
			"Washington Redskins"=>"Washington Redskins"			
		}
	end

	def get_odds

		headers = {}

		@sports.each do |name|
			puts("Hole #{name}-Daten von Sportingbet")
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

	def write_to_file(filename="output/sportingbet.xml")
		puts("Schreibe Daten in #{filename}")
		File.open(filename, "w") { |file|
			file.puts("<bookmaker name=\"Sportingbet\">")
			@sports.each do |sport|
				file.puts("<sport name=\"#{sport}\" id=\"#{@sportids[sport]}\">")
				@games[sport].each do |game|
# Wie soll sich die GameID berechnen?
					file.puts("<game id=\"1\">")

# Das Datum sollte umgerechnet werden (zB in yyyymmddhh)
					file.puts("<date>", "N/A", "</date>")
					file.puts("<time>", "N/A", "</time>")

					file.puts("<team1 id=\"N/A\">", @teams[game[0].strip], "</team1>")
					file.puts("<odd1>", game[2], "</odd1>")
					file.puts("<team2 id=\"N/A\">", @teams[game[1].strip], "</team2>")
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

sports = ['Baseball/MLB', 'Football/NFL']
ps = SportingbetScraper.new(sports)
ps.get_odds()
ps.write_to_file()

end
