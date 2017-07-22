# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'turbolinks:load', () ->
	$("#hocki_id_lh").change ->		
		if this.value.length==0
			id = "open"
		else
			id = this.value
		$.ajax
			url: "/hockis/"+id
			method: "PATCH"
			data: {modangki : true}
			success: (data) ->
				$(".container>.alert").remove()										
				$(".container").prepend("<div class='alert alert-success'>"+data+"</div>")
				$(".alert" ).fadeOut(4000);
			dataType: "text"
	setStandardTable("hocki","/hockis/destroy")
	$("#destroy_hocki").remove()	