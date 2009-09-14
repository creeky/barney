#!/usr/bin/ruby
# Script zum Scrapen der Wetten von pinnaclesports.com

require 'helpers/urltools.rb'

class PinnacleScraper
	def initialize(sports)
		@sports = sports
		@sporturls = {
# Meiner Meinung nach sollten die Sportarten nach Ligen unterteilt werden
			'Baseball/MLB' => 'http://www.pinnaclesports.com/League/Baseball/MLB/1/Lines.aspx',
			'Basketball/NBA' => 'http://www.pinnaclesports.com/League/Basketball/NBA/1/Lines.aspx',
			'Football/NFL' => 'http://www.pinnaclesports.com/League/Football/NFL/1/Lines.aspx',

			'Baseball' => 'http://www.pinnaclesports.com/League/Baseball/MLB/1/Lines.aspx'
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
			'Baseball/MLB' => /<td>(.{5,10})<\/td><td>(\d{3,4})<\/td><td>(.{5,25})<BR.*<\/td><td>&nbsp;&nbsp;&nbsp;(.{5,6})<\/td><td>OVER.*<\/td>\r\n..*\r\n..<td>(.{5,10})<\/td><td>(\d{3,4})<\/td><td>(.{5,25})<BR.*<\/td><td>&nbsp;&nbsp;&nbsp;(.{5,6})<\/td>/,
			'Football/NFL' => /<td>(.{5,10})<\/td><td>(\d{3,4})<\/td><td>([^<]+)<\/td><td>[^<]+<\/td><td>.+?(\d{1,2}.\d{3})<\/td><td>[^<]+<\/td><td [^>]+><\/td>[^<]+<\/tr><tr [^>]+>[^<]+<td>(.{5,10})<\/td><td>(\d{3,4})<\/td><td>([^<]+)<\/td><td>[^<]+<\/td><td>.+?(\d{1,2}.\d{3})<\/td><td>[^<]+<\/td>[^<]+<\/tr>/m,
# Brauche ich auch solches Kompatibilitätszeug?
			'Baseball' => /<td>(.{5,10})<\/td><td>(\d{3,4})<\/td><td>(.{5,25})<BR.*<\/td><td>&nbsp;&nbsp;&nbsp;(.{5,6})<\/td><td>OVER.*<\/td>\r\n..*\r\n..<td>(.{5,10})<\/td><td>(\d{3,4})<\/td><td>(.{5,25})<BR.*<\/td><td>&nbsp;&nbsp;&nbsp;(.{5,6})<\/td>/
		}
		@games = {}
	end

	def get_odds

		headers = {
		    'Cookie' => 'PriceStyle=decimal'
  		}

		@sports.each do |name|
			puts("Hole #{name}-Daten von Pinnaclesports")
			$stdout.flush
			text = ""
			post_request(@sporturls[name], "", headers) { |string|
				text = text + string
			}
#game: tag, id1, team1, odd1, zeit, id2, team2, odd2
			@games[name] = text.scan(@reg_expr[name])
			if(text == "")
				puts("Es konnten keine Daten gefunden werden")
				$stdout.flush
			end
		end
	end

	def write_to_file(filename="output/pinnacle.xml")
		puts("Schreibe Daten in #{filename}")
		File.open(filename, "w") { |file|
			file.puts("<bookmaker name=\"PinnacleSports\">")
			@sports.each do |sport|
				file.puts("<sport name=\"#{sport}\" id=\"#{@sportids[sport]}\">")
				@games[sport].each do |game|
# Wie soll sich die GameID berechnen?
					file.puts("<game id=\"1\">")

# Das Datum sollte umgerechnet werden (zB in yyyymmddhh)
					file.puts("<date>", game[0], "</date>")
					file.puts("<time>", game[4], "</time>")

					file.puts("<team1 id=\"#{game[1]}\">", game[2], "</team1>")
					file.puts("<odd1>", game[3], "</odd1>")
					file.puts("<team2 id=\"#{game[5]}\">", game[6], "</team2>")
					file.puts("<odd2>", game[7], "</odd2>")

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
ps = PinnacleScraper.new(sports)
ps.get_odds()
ps.write_to_file()

end
