# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'turbolinks:load', () ->	
	if($("#svdkh").hasClass("row"))		
		$("#masinhvien").change ->			
			this.form.submit()	

	$('#sinhviens tfoot th').each ()->
        title = $(this).text()
        $(this).html( '<input type="text" >')
    sinhvienTable=$("#sinhviens").DataTable
    	"dom": "lftip"
    	"pagingType": "simple_numbers"
    	"aoColumnDefs": [
    		{
    			"targets": [0,1]
    			"visible": false
    			"sortable": false
    			"searchable": false
    		}	      
	    	{
	        	"targets": 2
	        	"width": '10%'
	    	}
	    ]
	    "language":
            "url": "//cdn.datatables.net/plug-ins/9dcbecd42ad/i18n/Vietnamese.json"
	sinhvienTable.columns().every ()->
        that = this 
        $( 'input', this.footer() ).on 'keyup change', ()->
            if ( that.search() != this.value )
                that
                    .search( this.value )
                    .draw()
    edit_sinhvien_btn=$('#edit_sinhvien')
    destroy_sinhvien_btn=$('#destroy_sinhvien')
    edit_sinhvien_btn.hide()
    destroy_sinhvien_btn.hide()

    $('#sinhviens tbody').on 'click', 'tr', ()->
        $(this).toggleClass('selected')
        if sinhvienTable.rows('.selected').data().length==1
        	edit_sinhvien_btn.show()
        else
        	edit_sinhvien_btn.hide()
        if sinhvienTable.rows('.selected').data().length>0
        	destroy_sinhvien_btn.show()
        else
        	destroy_sinhvien_btn.hide()
    
    edit_sinhvien_btn.click ()->    	
	    new_address = sinhvienTable.row('tr.selected').data()[1]
	    if new_address != undefined	    	
	    	window.location = new_address   
    destroy_sinhvien_btn.click ()->
    	selects = sinhvienTable.rows('tr.selected').data()
	    Ids = new Array()
	    if selects.length == 0	    	
	    else
	      swal({
	        title: $('#delete_confirm_message').text(),
	        text: "",
	        type: "warning",
	        showCancelButton: true,
	        confirmButtonColor: "#DD6B55",
	        confirmButtonText: "OK",
	        cancelButtonText: "キャンセル",
	        closeOnConfirm: false,
	        closeOnCancel: false
	      }).then(() ->
	        len = selects.length
	        for i in [0...len]
	          Ids[i] = selects[i][0]

	        $.ajax({
	          url: ajax_url,
	          data:{ ids: Ids },
	          type: "DELETE",
	          dataType: "json"
	          success: (data) ->
	            swal("削除されました!", "", "success")
	            console.log("getAjax destroy_success:"+ data.destroy_success)
	            if data.destroy_success == "success"	              
	              sinhvienTable.rows('tr.selected').remove().draw()

	          failure: () ->
	            console.log("sinhvien_削除する keydown Unsuccessful")

	        })
	        edit_sinhvien_btn.hide()
	        destroy_sinhvien_btn.hide()

	      ,(dismiss) ->
	        if dismiss == 'cancel'	          
	          if selects.length == 0
	            edit_sinhvien_btn.hide()
	            destroy_sinhvien_btn.hide()
	          else
	            destroy_sinhvien_btn.show()
	            if selects.length == 1
	              edit_sinhvien_btn.show()
	            else
	              edit_sinhvien_btn.hide()
	      );