# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
hocphan_params= () ->
	q={}
	t=$("#khoavien_id").val()
	if(t!='' && t!='undefined')
		q.khoavien_id=t
	t=$("#tenhocphan").val()
	if(t!='' && t!='undefined')
		q.tenhocphan=t
	t=$("#mahocphan").val()
	if(t!='' && t!='undefined')
		q.mahocphan=t
	t=$("#tinchi").val()
	if(t!='' && t!='undefined')
		q.tinchi=t
	return q		
$(document).on 'turbolinks:load', () ->	
	if($("#hocphan_search").hasClass("row"))		
		$("#khoavien_id,#mahocphan,#tenhocphan,#tinchi").change ->
			search("/hocphans",hocphan_params(),"#hocphan_list","#results")					