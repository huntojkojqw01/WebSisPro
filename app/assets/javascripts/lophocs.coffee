# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
lophoc_params = () ->
	q={}
	t=$("#hocki_id").val()
	if(t!='' && t!= 'undefined')
		q.hocki_id=t
	t=$("#khoavien_id").val()
	if(t!='' && t!= 'undefined')
		q.khoavien_id=t
	t=$("#malophoc").val()
	if(t!='' && t!= 'undefined')
		q.malophoc=t
	t=$("#mahocphan").val()
	if(t!='' && t!= 'undefined')
		q.mahocphan=t
	return q
$(document).on 'turbolinks:load', () ->
	if($("#lophoc_search").hasClass("row"))
		$("#hocki_id,#khoavien_id,#malophoc,#mahocphan").change ->
			search("/lophocs",lophoc_params(),"#lophoc_list","#results")
			
