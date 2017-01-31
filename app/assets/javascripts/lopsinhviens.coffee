# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
lopsinhvien_params = () ->
	q={}
	t=$("#khoavien_id").val()
	if(t!='' && t!= 'undefined')
		q.khoavien_id=t
	t=$("#tenlopsinhvien").val()
	if(t!='' && t!= 'undefined')
		q.tenlopsinhvien=t
	return q
$(document).on 'turbolinks:load', () ->
	if($("#lopsinhvien_search").hasClass("row"))
		$("#khoavien_id,#tenlopsinhvien").change ->			
			search("/lopsinhviens",lopsinhvien_params(),"#lopsinhvien_list","#results")
		$("#lopsinhvien_list>ul>li>a").click (e) ->			
			e.preventDefault()
			search(this.href,{},"#lopsinhvien_list","#results")