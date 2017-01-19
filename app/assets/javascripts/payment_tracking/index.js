$(document).ready(function () {
  $(".payment-tracking-datatable").DataTable({
    columnDefs: [
      { "orderable": false, "targets": "actions" }
    ]
  });

  $(".payment_tracking_send_invoice").click(function () {
    var rentalId = $(this).attr("id").match(/\d+/).shift();
    $.ajax({
      method: 'post',
      url: Routes.payment_tracking_send_invoice_path(rentalId),
      success: function () { alert('Email Sent'); },
      error: function () { alert("failed to send email"); }
    });
  });
});
