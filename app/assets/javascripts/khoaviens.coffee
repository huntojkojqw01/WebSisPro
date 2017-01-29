# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'turbolinks:load', () ->
	$("#sinhviens").click ->			
		$.get
			url: "/sinhviens"
			data: "khoavien_id="+$(this).attr("khoavien_id")
			success: (data) ->
				$("#show").html $(data).find("#sinhviens").clone()
			dataType: "html"
	$("#hocphans").click ->		
		$.get
			url: "/hocphans"
			data: "khoavien_id="+$(this).attr("khoavien_id")
			success: (data) ->
				$("#show").html $(data).find("#hocphans").clone()
			dataType: "html"
	$("#giaoviens").click ->			
		$.get
			url: "/giaoviens"
			data: "khoavien_id="+$(this).attr("khoavien_id")
			success: (data) ->
				$("#show").html $(data).find("#giaoviens").clone()
			dataType: "html"	