# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
setStandardTable = (obj,ajax_url)->
	table_id='#'+obj+'s'
	model_name=obj
	$(table_id+' tfoot th').each ()->
        title = $(this).text()
        $(this).html( '<input type="text" >')
    oTable=$(table_id).DataTable
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
	oTable.columns().every ()->
        that = this 
        $( 'input', this.footer() ).on 'keyup change', ()->
            if ( that.search() != this.value )
                that
                    .search( this.value )
                    .draw()
    edit_btn=$('#edit_'+model_name)
    destroy_btn=$('#destroy_'+model_name)
    edit_btn.hide()
    destroy_btn.hide()

    $(table_id+' tbody').on 'click', 'tr', ()->
        $(this).toggleClass('selected')
        if oTable.rows('.selected').data().length==1
        	edit_btn.show()
        else
        	edit_btn.hide()
        if oTable.rows('.selected').data().length>0
        	destroy_btn.show()
        else
        	destroy_btn.hide()
    
    edit_btn.click ()->    	
	    new_address = oTable.row('tr.selected').data()[1]
	    if new_address != undefined	    	
	    	window.location = new_address   
    destroy_btn.click ()->
    	selects = oTable.rows('tr.selected').data()
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
	              oTable.rows('tr.selected').remove().draw()

	          failure: () ->
	            console.log("sinhvien_削除する keydown Unsuccessful")

	        })
	        edit_btn.hide()
	        destroy_btn.hide()

	      ,(dismiss) ->
	        if dismiss == 'cancel'	          
	          if selects.length == 0
	            edit_btn.hide()
	            destroy_btn.hide()
	          else
	            destroy_btn.show()
	            if selects.length == 1
	              edit_btn.show()
	            else
	              edit_btn.hide()
	      );
$(document).on 'turbolinks:load', () ->	
	if($("#svdkh").hasClass("row"))		
		$("#masinhvien").change ->			
			this.form.submit()	
	setStandardTable("sinhvien",'/sinhviens/destroy')
	