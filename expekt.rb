#!/usr/bin/ruby
# Script zum Scrapen der Wetten von pinnaclesports.com

require 'helpers/urltools.rb'

class ExpektScraper
	def initialize(sports)
		@sports = sports
		@sporturls = {
# Meiner Meinung nach sollten die Sportarten nach Ligen unterteilt werden
			'Baseball/MLB' => 'http://www.expekt.com/odds/eventsodds.jsp?oddstype=&gatype=-1&searchString=&betcategoryId=BSBMENUSAUSAFST&range=1000000&sortby=2'
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
			'Baseball/MLB' => /<tr class="oddsRow[1,2]">.+?<td align="center"> (\d{1,2}:\d{2}) <\/td>.+?<td align="center">([^-]+)-([^<]+).+?<td align="center">.+?<td align="center">.+?(\d{1,2}.\d{2}).+?<td align="center">.+?<td align="center">.+?(\d{1,2}.\d{2})/m
		}
		@games = {}
	end

	def get_odds

		headers = {
		    'Cookie' => 'JSESSIONID=A4B4AA7C5DDDAA07D1CD1E19C95107B7; expekt_lang=ger; expekt_partner=notag; __utma=40065014.802781510971680000.1248290951.1248290951.1248290951.1; __utmc=40065014; __utmz=40065014.1248290951.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none)'
  		}

		@sports.each do |name|
			puts("Hole #{name}-Daten von Expekt")
			text = ""
			get_request(@sporturls[name], headers) { |string|
				text = text + string
			}
File.open("junk.html", "w") { |file|
file.puts text
file.close() }
#game: time, team1, team2, odd1, odd2
			@games[name] = text.scan(@reg_expr[name])
			if(text == "")
				puts("Es konnten keine Daten gefunden werden")
			end
		end
	end

	def write_to_file(filename="expekt.xml")
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

					file.puts("<team1 id=\"N/A\">", game[1].strip, "</team1>")
					file.puts("<odd1>", game[3], "</odd1>")
					file.puts("<team2 id=\"N/A\">", game[2].strip, "</team2>")
					file.puts("<odd2>", game[4], "</odd2>")

					file.puts("</game>")
				end
				file.puts("</sport>")
			end
			file.puts("</bookmaker>")
			file.close()
		}
		puts("Fertig")
	end
end

#nur wenn das Script direkt gestartet wird, wird dieser Teil ausgeführt
if __FILE__ == $0

sports = ['Baseball/MLB']
ps = ExpektScraper.new(sports)
ps.get_odds()
ps.write_to_file()

end
