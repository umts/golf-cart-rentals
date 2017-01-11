$(document).ready(function () {
  $(".payment-tracking-datatable").DataTable({
    columnDefs: [
      { "orderable": false, "targets": "actions" }
    ]
  });

  $(".payment_tracking_send_invoice").click(function () {
    alert('Email Sent');
  });
});
