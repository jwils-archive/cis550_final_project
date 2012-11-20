# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'rexml/document'

def handle_games(doc, season)
	doc.elements.each("/Medals/*") do |ele|
		olympic_year = ele.name.split('_')[1]
		game = Game.find_or_create_by_year(olympic_year)
		game.season = season
		game.save
		ele.elements.each do |country|
			joincg = CountryGame.new do |cg| 
				c = Country.find_or_create_by_name(country.elements['country'].text)
				c.save
				cg.country = c
				cg.game = game
				cg.gold = country.elements['gold'].text
				cg.silver = country.elements['silver'].text
				cg.bronze = country.elements['bronze'].text
			end
			joincg.save
		end
	end
end

summer_games = File.new("#{Rails.root}/db/data/so.xml", "r")
summer_doc = REXML::Document.new(summer_games)

winter_games = File.new("#{Rails.root}/db/data/wo.xml", "r")
winter_doc = REXML::Document.new(winter_games)

handle_games(summer_doc, "summer")
handle_games(winter_doc, "winter")
#puts doc.root

