# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
sinhvien_params= () ->
	q={}
	t=$("#khoavien_id").val()
	if(t!='' && t!='undefined')
		q.khoavien_id=t
	t=$("#khoahoc").val()
	if(t!='' && t!='undefined')
		q.khoahoc=t
	t=$("#tensinhvien").val()
	if(t!='' && t!='undefined')
		q.tensinhvien=t
	t=$("#masinhvien").val()
	if(t!='' && t!='undefined')
		q.masinhvien=t
	t=$("#lopsinhvien_id").val()
	if(t!='' && t!='undefined')
		q.lopsinhvien_id=t
	return q		
$(document).on 'turbolinks:load', () ->	
	if($("#sinhvien_search").hasClass("row"))		
		$("#khoavien_id,#masinhvien,#tensinhvien,#lopsinhvien_id").change ->
			search("/sinhviens",sinhvien_params(),"#sinhvien_list","#results")
	if($("#svdkh").hasClass("row"))		
		$("#masinhvien").change ->			
			this.form.submit()			