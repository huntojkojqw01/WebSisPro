# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'turbolinks:load', () ->
  table_id="#chuongtrinhdaotaos"
  $(table_id + ' tfoot th').each ->  
    title = $(this).text()
    $(this).html '<input type="text" >'
  oTable = $(table_id).DataTable
    "dom": "lftip",
    "pagingType": "simple_numbers",
    "aoColumnDefs": [
      {
        "targets": [0],
        "visible": false,
        "sortable": false,
        "searchable": false
      }
      {
        "targets": [1],
        "width": "10%"
      }
    ]  
  oTable.columns().every ()->
    that = this
    return $('input', this.footer()).on 'keyup change', ()->
      if (that.search() != this.value)
        return that.search(this.value).draw()
  new_btn = $('button#new_chuongtrinhdaotao') 
  $('#edit_chuongtrinhdaotao').remove() 
  destroy_btn = $('#destroy_chuongtrinhdaotao')  
  destroy_btn.hide()
  $(table_id + ' tbody').on 'click', 'tr', ->
    $(this).toggleClass 'selected'    
    if oTable.rows('.selected').data().length > 0
      destroy_btn.show()
    else
      destroy_btn.hide()
  new_btn.click ()->
    new_address = $(this).attr("href")
    if new_address != ""
      return window.location = new_address    
  destroy_btn.click ()->
    Ids = undefined
    selects = undefined
    selects = oTable.rows('tr.selected').data()
    Ids = new Array
    if selects.length == 0
    else
      return swal(
        title: $('#delete_confirm_message').text()
        text: ''
        type: 'warning'
        showCancelButton: true
        confirmButtonColor: '#DD6B55'
        confirmButtonText: 'OK'
        cancelButtonText: 'キャンセル'
        closeOnConfirm: false
        closeOnCancel: false).then ()->
          i = undefined
          j = undefined
          len = undefined
          ref = undefined
          len = selects.length
          i = j = 0
          ref = len
          while (if 0 <= ref then j < ref else j > ref)
            Ids[i] = selects[i][0]
            i = if 0 <= ref then ++j else --j
          $.ajax
            url: '/chuongtrinhdaotaos/destroy'
            data: ids: Ids
            type: 'DELETE'
            dataType: 'json'
            success: (data) ->
              swal '削除されました!', '', 'success'
              console.log 'getAjax destroy_success:' + data.destroy_success
              if data.destroy_success == 'success'
                return oTable.rows('tr.selected').remove().draw()
              return
            failure: ->
              console.log '削除する keydown Unsuccessful'          
          destroy_btn.hide()
      , (dismiss) ->
        if dismiss == 'cancel'
          if selects.length == 0
            destroy_btn.hide()
          else
            destroy_btn.show()