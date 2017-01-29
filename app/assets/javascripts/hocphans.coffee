# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
@query_create = () ->
	q="/hocphans?mahocphan="+$("#mahocphan").val()+"&tenhocphan="+$("#tenhocphan").val()
	t=$("#khoavien_id").val()
	if(t!='')
		q+="&khoavien_id="+t	
	t=$("#tinchi").val()
	if(t!='')
		q+="&tinchi="+t
	return q+" #hocphan_list"
@search = (url) ->
	$("#results").load url, () ->
		$("#hocphan_list>ul>li>a").click (e) ->			
			e.preventDefault()								
			search($(this).attr("href")+" #hocphan_list")		
$(document).on 'turbolinks:load', () ->	
	$("#khoavien_id,#mahocphan,#tenhocphan,#tinchi").change -> search(query_create())
					