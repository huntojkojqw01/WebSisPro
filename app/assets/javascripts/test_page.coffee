# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'turbolinks:load', () ->	
	$("#clear").click ->
		$("#results" ).text("")
		
	$("#html").click ->
		$.get		    
			url: "/sieu"						
			success: ( data ) ->
				$("#results").html data
			dataType: "html"

	$("#json").click ->
		$.get
			url: "/sieu"
			success: ( data ) ->
				$("#results").html "<h1>Ma hocki: #{data.mahocki} Hoc phi #{data.dinhmuchocphi} Author #{data.chim}</h1>"
			dataType: "json"		    
			