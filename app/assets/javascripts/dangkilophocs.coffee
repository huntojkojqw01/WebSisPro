# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'turbolinks:load',()->
	setStandardTable('dangkilophoc','/dangkilophocs/destroy')
	$('#dslophoc tfoot th').each ->  
    title = $(this).text()
    $(this).html '<input type="text" >'
  oTable = $('#dslophoc').DataTable
    "dom": "lftip",
    "pagingType": "simple_numbers",
    "aoColumnDefs": [      
      { "targets": [0],"width": "10%"},
      { "targets": [1],"width": "10%"},
      { "targets": [2],"width": "10%"},
      { "targets": [3],"width": "10%"},
      { "targets": [4],"width": "30%"},
      { "targets": [5],"width": "5%"},
      { "targets": [6],"width": "5%"},
      {
        "targets": [7],        
        "sortable": false,
        "searchable": false,
        "width": "5%"        
      }
    ]  
  oTable.columns().every ()->
    that = this
    return $('input', this.footer()).on 'keyup change', ()->
      if (that.search() != this.value)
        return that.search(this.value).draw()