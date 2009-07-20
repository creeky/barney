#!/usr/bin/ruby
# Script für intertops.com, nutzt die PDA-Version der Seite

require 'helpers/urltools.rb'

class IntertopsScraper
	def initialize(sports)
		@sports = sports
		@sportqueries = {
			'Baseball/MLB' => "os=pRbtgge&sprtyp=BB&scrncd=SM&compno=1524"
		}
		@sportids = {
			'Baseball/MLB' => 101,
			'Basketball/NBA' => 201,
			'Football/NFL' => 301,
		}
		@reg_expr_uebersicht = {
			'Baseball/MLB' => /<A href="getsmbettype\.asp\?id=&os=pRbtgge&sprtyp=BB&scrncd=SM&compno=1524&machno=1524&betno=(\d{6})">/
		}
		@reg_expr_games = {
			'Baseball/MLB' => /(.{3}) \(.{3,15}\)   \((.{3,8})\)<\/A><br>\r\r<A href="getsmbet\.asp\?id=&os=pRbtgge&sprtyp=BB&scrncd=SM&compno=1524&bettyp=SM&betno=......&optino=SM.">(.{3}) \(.{3,15}\)   \((.{3,8})\)<\/A><br>/
		}
		@games = {}
		@teams = {
			"ARI"=>"Arizona Diamondbacks",
			"ATL"=>"Atlanta Braves",
			"BAL"=>"Baltimore Orioles",
			"BOS"=>"Boston Red Sox",
			"CHC"=>"Chicago Cubs",
			"CIN"=>"Cincinnati Reds",
			"COL"=>"Colorado Rockies",
			"CWS"=>"Chicago White Sox",
			"HOU"=>"Houston Astros",
			"LAA"=>"LAA Angels",
			"LOS"=>"Los Angeles Dodgers",
			"MIL"=>"Milwaukee Brevers",
			"MIN"=>"Minnesota Twins",
			"NYM"=>"New York Mets",
			"NYY"=>"New York Yankees",
			"OAK"=>"Oakland Athletics",
			"PHI"=>"Philadelphia Phillies",
			"PIT"=>"Pittsburgh Pirates",
			"SDG"=>"San Diego Padres",
			"SFO"=>"San Francisco Giants",
			"STL"=>"St. Louis Cardinals",
			"TAM"=>"Tampa Bay Rays",
			"TEX"=>"Texas Rangers",
			"WAS"=>"Washington Nationals"			
		}
	end

	def get_odds()
		@sports.each do |sport|
			puts("Hole #{sport}-Daten von Intertops")

			post_request("http://pda.intertops.com/German/selectbet.asp", @sportqueries[sport]) { |strings|
				strings.scan(@reg_expr_uebersicht[sport]).each do |id|
					text = ""
					post_request("http://pda.intertops.com/German/smbet.asp", @sportqueries[sport] + "betno=#{id[0]}&smcstype=none&bettyp=SM") { |strings2|
						text = text + strings2
					}
#game: team1, odd1, team2, odd2
					@games[sport] = text.scan(@reg_expr_games[sport])

					if(text == "")
						puts("Spieldaten konnten nicht gefunden werden (id=#{id[0]})")
					end
				end
			}
			if(@games[0] == nil)
				puts("Es konnten keine Daten gefunden werden")
			end
		end
	end

	def write_to_file(filename = "output/intertops.xml")
		puts("Schreibe Daten in #{filename}")
		File.open(filename, "w") { |file|
			file.puts("<bookmaker name=\"Intertops\">")
			@sports.each do |sport|
				file.puts("<sport name=\"#{sport}\" id=\"#{@sportids[sport]}\">")
				@games[sport].each do |game|
# Wie soll sich die GameID berechnen?
					file.puts("<game id=\"1\">")

# Wie ich ans Datum komme weiß ich nicht
#					file.puts("<date>", ?, "</date>")
#					file.puts("<time>", ?, "</time>")

					file.puts("<team1 id=\"0\">", @teams[game[0]], "</team1>")
					file.puts("<odd1>", game[1], "</odd1>")
					file.puts("<team2 id=\"0\">", @teams[game[2]], "</team2>")
					file.puts("<odd2>", game[3], "</odd2>")

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
is = IntertopsScraper.new(sports)
is.get_odds()
is.write_to_file()

end
