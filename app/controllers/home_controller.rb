class HomeController < ApplicationController
	def index
		@funds = ActiveRecord::Base.connection.execute("SELECT 50000 - SUM(eb.amount) as funds FROM event_bets eb WHERE user_id = #{current_user.id}")
		if @funds.first[0].nil?
			@funds = 50000
		else
			@funds = @funds.first[0]
		end
		@funds = '$%.2f' % @funds
	end

	#list all events
	def events
		@q = ActiveRecord::Base.connection.execute("select name, sport from events;")
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
		@q = ActiveRecord::Base.connection.execute("SELECT 
			IF (eb.event_id < 0, 'Country', 'Event'), 
			c.`name`, 
			IF (eb.event_id < 0, 
					CASE
						WHEN  eb.event_id = -1 THEN 'FIRST'
						WHEN  eb.event_id = -2 THEN 'SECOND'
						WHEN  eb.event_id = -3 THEN 'THIRD'
					END
				,
				    e.`name`
				),
				eb.amount,
					CONCAT(ROUND(((eb.amount/
						(SELECT SUM(btamt.amount)
						FROM
						event_bets btamt 
						WHERE btamt.event_id = eb.event_id
						AND btamt.country_id = eb.country_id)
		           *
		           (SELECT 
						SUM(ttl.amount) 
					FROM 
						event_bets ttl 
					WHERE 
						ttl.event_id = eb.event_id)) - eb.amount) / eb.amount, 2) , ' to 1')
			from event_bets eb, countries c,  events e
			WHERE user_id = #{user_id} and c.id = eb.country_id
			and (eb.event_id < 0 or e.id = eb.event_id) group by 1, 2, 3, 4")

		respond_to do |format|
			format.json { render json: @q}
		end
	end

	def event_medals
		event = params['event_id']

		@q = ActiveRecord::Base.connection.execute("SELECT c.`name`, 
			COUNT(IF(medal.`medal` = 'Gold', 1,NULL)), COUNT(IF(medal.`medal` = 'Silver', 1,NULL)), COUNT(IF(medal.`medal` = 'Bronze', 1,NULL)) 
			FROM athletes a, countries c, medals medal, events e Where medal.athlete_id = a.id 
			and c.id = a.country_id and medal.event_id = e.id and e.`name` = \"#{event}\" GROUP BY 1;")

		respond_to do |format|
			format.json { render json: @q}
		end
	end

	def country_medals
		@q = ActiveRecord::Base.connection.execute("SELECT c.`name`, ROUND(SUM(cg.gold)), ROUND(SUM(cg.silver))
			, ROUND(SUM(cg.bronze)) FROM countries c, country_games cg WHERE c.id = cg.country_id 
			group by 1;")
		respond_to do |format|
			format.json { render json: @q}
		end
	end


	def make_bet
		bet = EventBet.new
		bet.amount = params['amount']
		bet.save
		bet.user = current_user
		if not params['event'].nil?
			bet.event = Event.find_by_name(params['event'])
		elsif not params['place'].nil?
			bet.event_id = params['place']
		else
			bet.event_id = -2
		end

		bet.country = Country.find_by_name(params['country'])
		bet.save

		respond_to do |format|
			format.json { render json: bet}
		end
	end
end
