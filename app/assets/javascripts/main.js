var sCty,sEvt,tmp;
google.load("visualization", "1", {packages:["corechart"]});

function bethistory(){
	var bethistoryTable;
	$.ajax({
  		url: "/bets.json",
  		context: document.body
	}).done(function(data) { 

  		var bethistoryData = {
			"aaData": data,
			"aoColumns": [
				{ "sTitle": "Type" },
				{ "sTitle": "Country"},
				{ "sTitle": "Bet" ,"sClass":"center"},
				{ "sTitle": "Bet Amount" ,"sClass":"center"},
				{ "sTitle": "Calculated Odds" ,"sClass":"center"}
			]
		};
		bethistoryTable= $('#betHistTable').dataTable(bethistoryData);	
	});
}



/****
*
*	Country JS
*
*****/


function betCty1_table(){
	var ctycountryTable;
	
	
	/***
		GET: Countries with aggregate medal counts
	***/
	$.ajax({
  		url: "/country_medals.json",
  		context: document.body
	}).done(function(data) { 
		var ctycountryData = {
		"aaData": data,
		"aoColumns": [
			{ "sTitle": "Country" },
			{ "sTitle": "Gold" ,"sClass":"center"},
			{ "sTitle": "Silver" ,"sClass":"center"},
			{ "sTitle": "Bronze" ,"sClass":"center"},
			]
		};
			//<After completion>
		ctycountryTable= $('#ctyTable').dataTable(ctycountryData);	
		$("#ctyTable tbody tr").live("click", function(){
			sCty = ($(this).find('td').html());
			$("#bet-cty-label").html(sCty);
			$("#bet-cty-1").modal('hide');

			$("#bet-cty-2").modal();

		});
		//</After completion>
		});
	//Data
}





function betCty1_graph(){
	
	/***
		GET: Top country medal counts
	***/
	google.setOnLoadCallback(betCty1_Draw);
	function betCty1_Draw() {
		//Data
		var getdata = [
		  ['Country', 'Gold', 'Silver', 'Bronze'],
		  ['DBS',  1000,      400, 200],
		  ['BTN',  1170,      460,	100],
		  ['RSA',  660,       1120,	150],
		  ['USA',  1030,      540,	600]
		];
		
		
		//<After completion>
		var data = google.visualization.arrayToDataTable(getdata);
		
		
		var options = {
		  title: 'Medal Count by Country',
		  hAxis: {title: 'Country', titleTextStyle: {color: 'red'}},
		width:200
		};

		var chart = new google.visualization.ColumnChart(document.getElementById('infovis'));
		chart.draw(data, options);
		
		//<After completion>
	}
}





function betCty2_graph(){
	/***
		GET: Country's history for specified event
	***/

	google.setOnLoadCallback(betCty2_Draw);
	function betCty2_Draw() {
		//Data
		var getdata = [
		  ['Year', 'Gold', 'Silver', 'Bronze'],
		  ['2009',  100,      40, 20],
		  ['2010',  70,      40,	100],
		  ['2011',  660,       110,	150],
		  ['2012',  1030,      540,	600]
		];
	
		//<After completion>
		var data = google.visualization.arrayToDataTable(getdata);

		var options = {
		  title: 'History',
		  hAxis: {title: 'Year', titleTextStyle: {color: 'red'}},
		width:200
		};

		var chart = new google.visualization.ColumnChart(document.getElementById('infovis2'));
		chart.draw(data, options);
		//</After completion>
	}
	
	/***
			POST: Betting oods for Gold (default)
		***/
		
		//Data
		var odds = "1:5";
		
		//After completion
		$("#bet-cty-odds").html("Calculated Odds: "+odds);
	
	$("#betplace .gold").live("click",function(){
		/***
			POST: Betting oods for Gold
		***/
		
		//Data
		var odds = "1:3";
		tmp = "-1";
		
		//After completion
		$("#bet-cty-odds").html("Calculated Odds: "+odds);
	});
	$("#betplace .silver").live("click",function(){
		/***
			POST: Betting odds for Silver
		***/
		
		//Data
		var odds = "1:4";
		tmp = "-2";
		//After completion
		$("#bet-cty-odds").html("Calculated Odds: "+odds);
	});
	$("#betplace .bronze").live("click",function(){
		/***
			POST: Betting odds for Bronze
		***/
		
		//Data
		var odds = "1:10";
		tmp = "-3";
		//After completion
		$("#bet-cty-odds").html("Calculated Odds: "+odds);
	});
	
	

	$("#bet-cty-btn").click(function(){
	
		/***
			POST: Country Bet (Country Name: sCty, Place: $("#betplace").val(), Bet Amount: $("#bet-cty-input").val())
		***/
		
		$.ajax({
	        url: "/make_bet",
	        type: "post",
	        data: {
	        'country' : sCty, 
	        'amount' : document.getElementById('bet-cty-input').value,
	        'place' : tmp,
	        },
	        // callback handler that will be called on success
	        success: function(response){
	        	document.location.reload(true)
	            // log a message to the console
	            // console.log("Hooray, it worked!");
	        }
    	});
		//After Completion
		$("#bet-cty-input").val('');
		$("#bet-cty-2").modal('hide');
	});	
}



/****
*
*	Event JS
*
****/
function betEvt1_table(){
	var evtTable;
	
	/***
		GET: List of Olympic Events
	***/
	$.ajax({
  		url: "/events.json",
  		context: document.body
	}).done(function(data) { 
		var evtData = {
		"aaData":data,
		"aoColumns": [
			{ "sTitle": "Event" }
		]
	};
		//</After completion>
		//<After completion>
	evtTable= $('#evtTable').dataTable(evtData);	
	
	$("#evtTable tbody tr").live("click", function(){
		sEvt = ($(this).find('td').html());
		$("#bet-evt-label").html(sEvt+": Select a Country");
		$("#bet-evt-1").modal('hide');
		$("#bet-evt-2").modal();
		betEvt2_table();

	});
	//</After completion>
	});


	//Data
}




function betEvt2_table(){
	var evtCountryTable;
	
	/***
		GET: Countries that participate in specified event
	***/
	
	//Data
	$.ajax({
  		url: "/event_medals/" + sEvt + ".json",
  		context: document.body
	}).done(function(data) { 
		var evtCountryData = {
		"aaData": data,
		"aoColumns": [
			{ "sTitle": "Country" },
			{ "sTitle": "Gold" ,"sClass":"center"},
			{ "sTitle": "Silver" ,"sClass":"center"},
			{ "sTitle": "Bronze" ,"sClass":"center"},
		]
	};
	evtCountryTable= $('#evt-ctyTable').dataTable(evtCountryData);	
	
	$("#evt-ctyTable tbody tr").live("click", function(){
			sCty = ($(this).find('td').html());
			$("#bet-evt-label2").html(sEvt +" : " + sCty);
			$("#bet-evt-2").modal('hide');
			evtCountryTable.fnDestroy();
			$("#bet-evt-3").modal();
		
	});
	});

	
	
	//<After completion>
	
	//</After completion>
}




function betEvt2_graph(){
	/***
		GET: Top counties for specified event
	***/
	google.setOnLoadCallback(betEvt2_Draw);
	function betEvt2_Draw() {
	
		//Data
		var getdata = [
		  ['Country', 'Gold', 'Silver', 'Bronze'],
		  ['DBS',  1000,      400, 200],
		  ['BTN',  1170,      460,	100],
		  ['RSA',  660,       1120,	150],
		  ['USA',  1030,      540,	600]
		];
	
		//<After completion>
		var data = google.visualization.arrayToDataTable(getdata);

		var options = {
			title: 'Medal Count by Country',
			hAxis: {title: 'Country', titleTextStyle: {color: 'red'}},
			width:200
		};

		var chart = new google.visualization.ColumnChart(document.getElementById('bet-evt-vis-2'));
		chart.draw(data, options);
		//<After completion>
	}
}




function betEvt3_graph(){
	/***
		GET: Country's history for specified event
	***/

	google.setOnLoadCallback(betEvt3_Draw);
	function betEvt3_Draw() {
	
		//Data
		var getdata = [
		  ['Country', 'Gold', 'Silver', 'Bronze'],
		  ['DBS',  1000,      400, 200],
		  ['BTN',  1170,      460,	100],
		  ['RSA',  660,       1120,	150],
		  ['USA',  1030,      540,	600]
		];
		
		
		//<After completion>
		var data = google.visualization.arrayToDataTable(getdata);
		

		var options = {
		  title: 'History',
		  hAxis: {title: 'Country', titleTextStyle: {color: 'red'}},
		width:200
		};

		var chart = new google.visualization.ColumnChart(document.getElementById('bet-evt-vis-3'));
		chart.draw(data, options);
		
		//</After completion>
	}
	
	/***
			POST: Betting oods for specified bet and country
		***/
		
		//Data
		var odds = "1:4";
		
		//After completion
		$("#bet-evt-odds").html("Calculated Odds: "+odds);

	$("#bet-evt-btn").click(function(){
	
		/***
			POST: Event Bet (Event Name : sEvt, Country Name : sCty, Bet Amount : $("#bet-evt-input").val())
		***/
		$.ajax({
	        url: "/make_bet",
	        type: "post",
	        data: {
	        'country' : sCty, 
	        'event' : sEvt, 
	        'amount' : document.getElementById('bet-evt-input').value
	        },
	        // callback handler that will be called on success
	        success: function(response){
	            // log a message to the console
	            console.log("Hooray, it worked!");
	            document.location.reload(true)
	        }
    	});
		//After completion
		$("#bet-evt-input").val('');
		$("#bet-evt-3").modal('hide');
	});
}