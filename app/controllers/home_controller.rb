class HomeController < ApplicationController
	def index
		
	end

	#list all events
	def events
		@q = ActiveRecord::Base.connection.execute("select name from events;")
		respond_to do |format|
			format.json { render json: @q}
		end
	end

	def countries
		@q = ActiveRecord::Base.connection.execute("select id, name from countries;")
	end

	#get bets for a given user
	def bets
		user_id = current_user.id
		@q = ActiveRecord::Base.connection.execute("SELECT * from event_bets WHERE user_id = #{user_id}")

		respond_to do |format|
			format.json { render json: @q}
		end
	end

	def event_medals
		event = params['event_id']

		@q = ActiveRecord::Base.connection.execute("SELECT c.`name`, 
			COUNT(medal.`medal` = 'Gold'), COUNT(medal.`medal` = 'Silver'), COUNT(medal.`medal` = 'Bronze') 
			FROM athletes a, countries c, medals medal, events e Where medal.athlete_id = a.id 
			and c.id = a.country_id and medal.event_id = e.id and e.`name` = #{event} GROUP BY 1;")

		respond_to do |format|
			format.json { render json: @q}
		end
	end

	def country_medals
		@q = ActiveRecord::Base.connection.execute("SELECT c.`name`, SUM(cg.gold), SUM(cg.silver)
			, SUM(cg.bronze) FROM countries c, country_games cg WHERE c.id = cg.country_id 
			group by 1;")
		respond_to do |format|
			format.json { render json: @q}
		end
	end


	#integrate this into displaying bets somehow
	def pari_bet(bet_type, bet_data, country, bet_amt)

		#first query the SQL database to gather the required info
		
		if(bet_type == 'e') #event bet
			
			#first get total pot
			rs = ActiveRecord::Base.connection.execute("SELECT SUM(amt)
							FROM EventBets eb
							WHERE event_id = \"#{bet_data}\"
							")
							
			row = rs.fetch_row
			total_pot = row[0]
			
			#next find total money bet on the same country the user
			#wants to bet on
			rs = ActiveRecord::Base.connection.execute("SELECT SUM(eb.amt)
							FROM EventBets eb, Countries c
							WHERE eb.event_id = \"#{bet_data}\" AND
							c.name=\"#{country}\" AND 
							eb.country_id = c.id						
							")
							
			row = rs.fetch_row
			country_pot = row[0]
			
		else #country total medal bet
			
			#first get total pot
			rs = ActiveRecord::Base.connection.execute("SELECT SUM(amt)
							FROM CountryBets cb
							WHERE bet_id = \"#{bet_data}\"
							")
			
			row = rs.fetch_row
			total_pot = row[0]
			
			#next find total money bet on the same country the user
			#wants to bet on
			rs = ActiveRecord::Base.connection.execute("SELECT SUM(cb.amt)
							FROM CountryBets cb, Countries c
							WHERE cb.bet_id = \"#{bet_data}\" AND
							c.name=\"#{country}\" AND 
							cb.country_id = c.id						
							")
							
			row = rs.fetch_row
			country_pot = row[0]
			
		end	

		#calculate expected payout
		exp_payout = (bet_amt/country_pot) * total_pot
		
		#calculate odds
		o = (exp_payout - bet_amt)/bet_amt
		odds = "#{o} to 1"
		
		return exp_payout, odds
	end

end
