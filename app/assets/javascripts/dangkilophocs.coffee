# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
params=() ->
	q={}
	t=$("#hocki_id").val()
	if(t!='' && t!='undefined')
		q.hocki_id=t
	t=$("#masinhvien").val()
	if(t!='' && t!='undefined')
		q.masinhvien=t
	t=$("#malophoc").val()
	if(t!='' && t!='undefined')
		q.malophoc=t
	return q
getData= (url,data) ->
	$.get
		url: url
		data: data
		success: (respond) ->				
			$("#dklh_list").html $(respond).find("#dklh_list").clone()
			$("#dklh_list>ul>li>a").click (e)->
				e.preventDefault()
				getData($(this).attr("href"),{})					
		dataType: "html"
$(document).on 'turbolinks:load', () ->
	if($("#dangkilophoc").hasClass("row"))
		$("#hocki_id,#mahocphan,#malophoc").change () ->						
			getData("/dangkilophocs",params())
		$("#lophoc_list>ul>li>a").click (e)->
				e.preventDefault()
				getData($(this).attr("href"),{})
	if($("#dklh_search").hasClass("row"))
		$("#hocki_id,#masinhvien,#malophoc").change () ->						
			getData("/dangkilophocs",params())
		$("#dklh_list>ul>li>a").click (e)->
				e.preventDefault()
				getData($(this).attr("href"),{})