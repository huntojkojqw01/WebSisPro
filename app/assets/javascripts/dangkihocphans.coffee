# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
params=() ->
	q={}
	t=$("#khoavien_id").val()
	if(t!='' && t!='undefined')
		q.khoavien_id=t
	t=$("#mahocphan").val()
	if(t!='' && t!='undefined')
		q.mahocphan=t
	t=$("#tenhocphan").val()
	if(t!='' && t!='undefined')
		q.tenhocphan=t
	return q
getData= (url,data) ->
	$.get
		url: url
		data: data
		success: (respond) ->				
			$("#hocphan_list").html $(respond).find("#hocphan_list").clone()
			$("#hocphan_list>ul>li>a").click (e)->
				e.preventDefault()
				getData($(this).attr("href"),{})					
		dataType: "html"
$(document).on 'turbolinks:load', () ->
	if($("#dangkihocphan").hasClass("row"))
		$("#khoavien_id,#mahocphan,#tenhocphan").change () ->						
			getData("/dangkihocphans/"+$("#hocphan_list").attr("sinhvien_id"),params())
		$("#hocphan_list>ul>li>a").click (e)->
				e.preventDefault()
				getData($(this).attr("href"),{})