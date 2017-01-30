# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
giaovien_params= () ->
	q={}
	t=$("#khoavien_id").val()
	if(t!='' && t!='undefined')
		q.khoavien_id=t
	t=$("#tengiaovien").val()
	if(t!='' && t!='undefined')
		q.tengiaovien=t
	return q
@search = (url,data,src,dest) ->
	$.get
		url: url
		data: data		
		success: (respond) ->
			$(dest).html $(respond).find(src).clone()
			$(src+">ul>li>a").click (e) ->					
				e.preventDefault()								
				search($(this).attr("href"),{},src,dest)
		dataType: "html"	
$(document).on 'turbolinks:load', () ->	
	if($("#giaovien_search").hasClass("row"))		
		$("#khoavien_id,#tengiaovien").change ->
			search("/giaoviens",giaovien_params(),"#giaovien_list","#results")