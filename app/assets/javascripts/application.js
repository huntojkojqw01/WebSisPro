// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require turbolinks
//= require sweetalert2
//= require_tree .
var setStandardTable;

setStandardTable = function(obj, ajax_url) {
  var destroy_btn, edit_btn, model_name, oTable, table_id;
  table_id = '#' + obj + 's';
  model_name = obj;
  $(table_id + ' tfoot th').each(function() {
    var title;
    title = $(this).text();
    return $(this).html('<input type="text" >');
  });
  oTable = $(table_id).DataTable({
    "dom": "lftip",
    "pagingType": "simple_numbers",
    "aoColumnDefs": [
      {
        "targets": [0, 1],
        "visible": false,
        "sortable": false,
        "searchable": false
      }, {
        "targets": 2,
        "width": '10%'
      }
    ]
  });
  oTable.columns().every(function() {
    var that;
    that = this;
    return $('input', this.footer()).on('keyup change', function() {
      if (that.search() !== this.value) {
        return that.search(this.value).draw();
      }
    });
  });
  edit_btn = $('#edit_' + model_name);
  destroy_btn = $('#destroy_' + model_name);
  edit_btn.hide();
  destroy_btn.hide();
  $(table_id + ' tbody').on('click', 'tr', function() {
    $(this).toggleClass('selected');
    if (oTable.rows('.selected').data().length === 1) {
      edit_btn.show();
    } else {
      edit_btn.hide();
    }
    if (oTable.rows('.selected').data().length > 0) {
      return destroy_btn.show();
    } else {
      return destroy_btn.hide();
    }
  });
  edit_btn.click(function() {
    var new_address;
    new_address = oTable.row('tr.selected').data()[1];
    if (new_address !== void 0) {
      return window.location = new_address;
    }
  });
  return destroy_btn.click(function() {
    var Ids, selects;
    selects = oTable.rows('tr.selected').data();
    Ids = new Array();
    if (selects.length === 0) {

    } else {
      return swal({
        title: $('#delete_confirm_message').text(),
        text: "",
        type: "warning",
        showCancelButton: true,
        confirmButtonColor: "#DD6B55",
        confirmButtonText: "OK",
        cancelButtonText: "キャンセル",
        closeOnConfirm: false,
        closeOnCancel: false
      }).then(function() {
        var i, j, len, ref;
        len = selects.length;
        for (i = j = 0, ref = len; 0 <= ref ? j < ref : j > ref; i = 0 <= ref ? ++j : --j) {
          Ids[i] = selects[i][0];
        }
        $.ajax({
          url: ajax_url,
          data: {
            ids: Ids
          },
          type: "DELETE",
          dataType: "json",
          success: function(data) {
            swal("削除されました!", "", "success");
            console.log("getAjax destroy_success:" + data.destroy_success);
            if (data.destroy_success === "success") {
              return oTable.rows('tr.selected').remove().draw();
            }
          },
          failure: function() {
            return console.log("sinhvien_削除する keydown Unsuccessful");
          }
        });
        edit_btn.hide();
        return destroy_btn.hide();
      }, function(dismiss) {
        if (dismiss === 'cancel') {
          if (selects.length === 0) {
            edit_btn.hide();
            return destroy_btn.hide();
          } else {
            destroy_btn.show();
            if (selects.length === 1) {
              return edit_btn.show();
            } else {
              return edit_btn.hide();
            }
          }
        }
      });
    }
  });
};
$(document).on('turbolinks:load', function() {
  setTimeout(function() {
    $('.alert').fadeOut('normal');
  }, 4000);
});