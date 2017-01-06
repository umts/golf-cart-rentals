
// Helper method for incurred_incidentals _form.html
// Populate incurred_incidental amount textbox with base amount shown for incidental_type dropdown menu
$(document).ready(function() {
  $("#select_incidental_type").change(function() {
    $("#select_incidental_type option:selected").map(function() {
      var price = $(this).text().split('$')[1].split(')')[0]; // Parsing for extract price, regardless of number of digits
      $("#incurred_incidental_amount").val(price);
    });
  });
});
