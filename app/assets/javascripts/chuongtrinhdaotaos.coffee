# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'turbolinks:load', () ->
	if($("#show_ctdts").hasClass("row"))
		$("#sort_by").change ->			
			search("/chuongtrinhdaotaos/"+$("#results").attr("lopsinhvien_id"),this.id+"="+this.value,"#results","#results")