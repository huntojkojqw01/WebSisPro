# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'turbolinks:load', () ->
	if($("#hocki_list").hasClass("row"))
		$("#hocki_id_lh").change ->
			$.ajax
				url: "/hockis/"+this.value
				method: "PATCH"
				data: {modangki : true}
				success: (data) ->
					$(".container>.alert").remove()										
					$(".container").prepend("<div class='alert alert-success'>"+data+"</div>")
				dataType: "text"		