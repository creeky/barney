#!/usr/bin/ruby
# Script zum Scrapen der Wetten von pinnaclesports.com

require 'helpers/urltools.rb'

class PinnacleScraper
	def initialize(sports)
		@sports = sports
		@sporturls = {
			'Baseball' => 'http://www.pinnaclesports.com/League/Baseball/MLB/1/Lines.aspx',
			'Basketball' => 'http://www.pinnaclesports.com/League/Basketball/NBA/1/Lines.aspx',
			'Football' => 'http://www.pinnaclesports.com/League/Football/NFL/1/Lines.aspx'
		}
		@reg_expr = {
			'Baseball' => /<td>(.{5,10})<\/td><td>(\d{3,4})<\/td><td>(.{5,25})<BR.*<\/td><td>&nbsp;&nbsp;&nbsp;(.{5,6})<\/td><td>OVER.*<\/td>\r\n..*\r\n..<td>(.{5,10})<\/td><td>(\d{3,4})<\/td><td>(.{5,25})<BR.*<\/td><td>&nbsp;&nbsp;&nbsp;(.{5,6})<\/td>/
		}
#game: tag, id1, team1, odd1, zeit, id2, team2, odd2
		@games = {}
	end

	def get_odds

		headers = {
		    'Cookie' => 'PriceStyle=decimal'
  		}

		@sports.each do |name|
			text = ""
			post_request(@sporturls[name], "", headers) { |string|
				text = text + string
			}
			puts(text)
			@games[name] = text.scan(@reg_expr[name])
		end
	end

	def write_to_file(filename="pinnacle.xml")
		File.open(filename, "w") { |file|
			file.puts("<bookmaker name=\"PinnacleSports\">")
			@sports.each do |sport|
				file.puts("<sport name=\"#{sport}\" id=\"1\">")
				@games[sport].each do |game|
					file.puts("<game id=\"1\">")

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
	end
end

#nur wenn das Script direkt gestartet wird, wird dieser Teil ausgeführt
if __FILE__ == $0

sports = ['Baseball']
ps = PinnacleScraper.new(sports)
ps.get_odds()
ps.write_to_file()

end
