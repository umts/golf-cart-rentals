// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require jquery-readyselector
//= require 'jquery.backstretch'
//= require bootstrap-sprockets
//= require moment
//= require js-routes
//= require fullcalendar
//= require bootstrap-datetimepicker
//= require signature-pad
//= require_tree .

// Helper method for incurred_incidentals _form.html
// Populate incurred_incidental amount textbox with base amount shown for incidental_type dropdown menu
$(document).ready(function() {
  $('[data-toggle="tooltip"]').tooltip(); //init tooltips
  
  $("#select_incidental_type").change(function() {
    $("#select_incidental_type option:selected").map(function() {
      var price = $(this).text().split('$')[1].split(')')[0]; // Parsing for extract price, regardless of number of digits
      $("#incurred_incidental_amount").val(price);
    });
  });
});
