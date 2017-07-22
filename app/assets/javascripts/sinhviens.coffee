# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'turbolinks:load', () ->	
	setStandardTable("sinhvien",'/sinhviens/destroy')
	$('#caclopdahoc').DataTable
    "dom": "lftip",
    "pagingType": "simple_numbers",
    "aoColumnDefs": [      
      { "targets": [0],"width": "10%"},
      { "targets": [1],"width": "10%"},
      { "targets": [2],"width": "30%"},
      { "targets": [3],"width": "10%"},
      { "targets": [4],"width": "10%"},
      { "targets": [5],"width": "5%"},
      { "targets": [6],"width": "5%"},
      { "targets": [7],"width": "5%"}
    ]  