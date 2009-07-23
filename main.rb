#!/usr/bin/ruby
#Script um Daten von allen Seiten auf einmal zu sammeln

sports = ['Baseball/MLB']

# pinnacle:
require 'pinnacle.rb'

s = PinnacleScraper.new(sports)
s.get_odds()
s.write_to_file("output/pinnacle.xml")

# intertops:
require 'intertops.rb'

s = IntertopsScraper.new(sports)
s.get_odds()
s.write_to_file("output/intertops.xml")

# expekt:
require 'expekt.rb'

s = ExpektScraper.new(sports)
s.get_odds()
s.write_to_file("output/expekt.xml")
