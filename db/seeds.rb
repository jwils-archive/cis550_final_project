# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'rexml/document'
require 'Nokogiri'

def handle_games(doc, season)
	doc.elements.each("/Medals/*") do |ele|
		olympic_year = ele.name.split('_')[1]
		game = Game.find_or_create_by_year_and_season(olympic_year, season)
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

events = File.read("#{Rails.root}/db/data/events_unique.txt", "r")
sports = File.read("#{Rails.root}/db/data/sports_unique.txt", "r")

event_to_sport = events.each_line.zip(sports.each_line)

event_to_sport.each do |event, sport|
	s = Sport.find_or_create_by_name(sport.rstrip)
	e = Event.find_or_create_by_name(event.rstrip)
	e.sport = s
	e.save
end


players = Nokogiri::XML(File.open("#{Rails.root}/db/data/Athletes.xml", "r"))
players.xpath("//Record").each do |ele|
	player = Athlete.new do |a|
		a.full_name = ele.css("Full_Name").text
		a.gender = ele.css("Gender").text
		a.DOB = ele.css("DOB").text
		a.country = Country.find_or_create_by_name(ele.css('Country').text.split(' ')[0])
	end
	player.save
	ele.css('Medal_history').each do |medal|
		md = Medal.new do |m|
			m.athlete = player
			m.event = Event.find_or_create_by_name(medal.css('Event').text)
			games_year = medal.css('Games').text.split(' ')[0].to_i
			games_season = medal.css('Games').text.split(' ')[1]
			m.game = Game.find_by_year_and_season(games_year, games_season)
			m.medal = medal.css('Medal').text
		end
		md.save
	end
end


