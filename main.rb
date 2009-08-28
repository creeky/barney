#!/usr/bin/ruby
#Script um Daten von allen Seiten auf einmal zu sammeln

sports = Array.new
anbieter = Array.new
outputdir = ""

argmode = "none"
ARGV.each do |arg|
	case arg
	when "-o" then argmode = "outputdir"
	when "-a" then argmode = "anbieter"
	when "-s" then argmode = "sports"
	else
		case argmode
		when "none"
			puts("Hilfe", "Optionen:", "   -s Sport/Liga", "   -o Ausgabeverzeichnis", "   -a Anbieter")
			exit(0)
		when "sports"
			sports.push(arg)
		when "outputdir"
			outputdir = arg
			argmode = "none"
		when "anbieter"
			anbieter.push(arg)
		end
	end
end

if(sports.empty?())
	sports = ['Baseball/MLB']
end
if(outputdir == "")
	outputdir = "output"
end
if(anbieter.empty?())
	anbieter = ["pinnacle", "intertops", "expekt", "bwin", "sportingbet"]
end

# pinnacle:

if(anbieter.include?("pinnacle"))
	require 'pinnacle.rb'

	s = PinnacleScraper.new(sports)
	s.get_odds()
	s.write_to_file( outputdir + "/pinnacle.xml")
end

# intertops:

if(anbieter.include?("intertops"))
	require 'intertops.rb'

	s = IntertopsScraper.new(sports)
	s.get_odds()
	s.write_to_file( outputdir + "/intertops.xml")
end

# expekt:

if(anbieter.include?("expekt"))
	require 'expekt.rb'

	s = ExpektScraper.new(sports)
	s.get_odds()
	s.write_to_file( outputdir + "/expekt.xml")
end

# bwin:

if(anbieter.include?("bwin"))
	require 'bwin.rb'

	s = BWinScraper.new(sports)
	s.get_odds()
	s.write_to_file( outputdir + "/bwin.xml")
end

# sportingbet:

if(anbieter.include?("sportingbet"))
	require 'sportingbet.rb'

	s = SportingbetScraper.new(sports)
	s.get_odds()
	s.write_to_file( outputdir + "/sportingbet.xml")
end

# bet365:

if(anbieter.include?("bet365"))
	require 'bet365.rb'

	s = Bet365Scraper.new(sports)
	s.get_odds()
	s.write_to_file( outputdir + "/bet365.xml")
end
