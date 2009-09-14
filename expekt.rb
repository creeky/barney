#!/usr/bin/ruby
# Script zum Scrapen der Wetten von expekt.com

require 'helpers/urltools.rb'

class ExpektScraper
	def initialize(sports)
		@sports = sports
		@sporturls = {
# Meiner Meinung nach sollten die Sportarten nach Ligen unterteilt werden
			'Baseball/MLB' => 'http://www.expekt.com/odds/eventsodds.jsp?betcategoryId=BSBMENUSAUSAFST&range=1000000&sortby=2',
			'Football/NFL' => 'http://www.expekt.com/odds/eventsodds.jsp?range=1000000&sortby=2&active=betting&betcategoryId=AMFMENUSAUSANFL'
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
			'Baseball/MLB' => /<tr class="oddsRow[1,2]">.+?<td align="center"> (\d{1,2}:\d{2}) <\/td>.+?<td align="center">([^-]+)-([^<]+).+?<td align="center">.+?<td align="center">.+?(\d{1,2}.\d{2}).+?<td align="center">.+?<td align="center">.+?(\d{1,2}.\d{2})/m,
			'Football/NFL' => /<tr class="oddsRow[1,2]">.+?<td align="center"> (\d{1,2}:\d{2}) <\/td>.+?<td align="center">([^-]+)-([^<]+).+?<td align="center">.+?<td align="center">.+?(\d{1,2}.\d{2}).+?<td align="center">.+?<td align="center">.+?(\d{1,2}.\d{2})/m
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
			"St Louis Cardinals"=>"St Louis Cardinals",
			"Tampa Bay Rays"=>"Tampa Bay Rays",
			"Texas Rangers"=>"Texas Rangers",
			"Toronto Bluejays"=>"Toronto Blue Jays",
			"Washington Nationals"=>"Washington Nationals",

			#Football/NFL
			"Buffalo Bills"=>"Buffalo Bills",
			"New England Patriots"=>"New England Patriots",
			"San Diego Chargers"=>"San Diego Chargers",
			"Oakland Raiders"=>"Oakland Raiders"
		}
	end

	def get_odds

		headers = {
		    'Cookie' => 'expekt_lang=ger'
		}

		@sports.each do |name|
			puts("Hole #{name}-Daten von Expekt")
			$stdout.flush
			text = ""
			get_request(@sporturls[name], headers) { |string|
				text = text + string
			}

#game: time, team1, team2, odd1, odd2
			@games[name] = text.scan(@reg_expr[name])
			if(text == "")
				puts("Es konnten keine Daten gefunden werden")
				$stdout.flush
			end
		end
	end

	def write_to_file(filename="output/expekt.xml")
		puts("Schreibe Daten in #{filename}")
		File.open(filename, "w") { |file|
			file.puts("<bookmaker name=\"Expekt\">")
			@sports.each do |sport|
				file.puts("<sport name=\"#{sport}\" id=\"#{@sportids[sport]}\">")
				@games[sport].each do |game|
# Wie soll sich die GameID berechnen?
					file.puts("<game id=\"1\">")

# Das Datum sollte umgerechnet werden (zB in yyyymmddhh)
					file.puts("<date>", "N/A", "</date>")
					file.puts("<time>", game[0], "</time>")

					file.puts("<team1 id=\"N/A\">", @teams[game[1].strip], "</team1>")
					file.puts("<odd1>", game[3], "</odd1>")
					file.puts("<team2 id=\"N/A\">", @teams[game[2].strip], "</team2>")
					file.puts("<odd2>", game[4], "</odd2>")

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
ps = ExpektScraper.new(sports)
ps.get_odds()
ps.write_to_file()

end
