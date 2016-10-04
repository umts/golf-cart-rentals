//Clear search fields //Add <%= f.submit "Clear", :name => nil, :id => :q_reset %> to the bottom of your search form
$(function(){
  $("#q_reset").click(function(index, element){
    $("input,select").not(':submit').val('')
  });
});

//Append the 'required' class to any element with a required field in it so that css can prepend an asterisk to it
$(function(){
  $("[required]").each(function(index, element){
    $(element).parent().addClass("required");
    $(element).parents("form").addClass("with-required");
    $("[name='contacted-customer?']").bootstrapSwitch();
  });
});

//Allow multi-select, datepicker, and timepicker to work on all browsers
$(document).ready(function() {
    $('.selectpicker').selectpicker();

    $( ".datepicker" ).datetimepicker({
      format: 'YYYY-MM-DD',
      showTodayButton: true,
      showClear: true,
      showClose: true
    }).on('dp.change', function(ev) {
      if(window.location.pathname == '/rentals/new') {
        calculate_price();
      }
    });

    $( ".timepicker" ).datetimepicker({
      format: 'h:mm A'
    });

    //Adds listeners to select inputs to toggle disclaimers on rental schedule page
    $(document.getElementsByName("rental[item_type_id]")).each(function() {
      $(this).change(function () {
        $(this).closest("form").find(".disclaimer").each(function() {
          $(this).toggleClass("disclaimer-hidden")
        })
      })
    })

    //Single day submit button function for updating end time
    $('#TOC').click(function () {
      $('#rental_end_time').val($('#rental_start_time').val())
    })
});

//Toggle the loading div
//Give a form onsubmit: "toggle_loading()" to allow forms that submit to long actions to show the loading div
$(function(){
  $('#loading').hide();
});
function toggle_loading(){
  $('#loading').toggle();
}

//Toggle a forms submit button when a checkbox is checked/unchecked
function accept_and_enable(box)
{
    var submit = $(box).closest('form').find("input[type='submit']")[0];

    if (box.checked === true)
    {
        submit.disabled = false;
    }
    else
    {
        submit.disabled = true;
    }
}

function calculate_price()
{
  // Grab the Price of the item types
  // TODO: Switch out index id for item type names
  // TODO: json for item type pricing and rates
  var item_type_prices = new Array();
  item_type_prices[1] = 40;
  item_type_prices[2] = 60;

  var item_type_daily_rates = new Array();
  item_type_daily_rates[1] = 35;
  item_type_daily_rates[2] = 40;

  var item_type_price = 0;
  var rentalForm = document.forms["rental_reservation"];

  var cart = rentalForm.elements["rental_item_type_id"];
  item_type_price = item_type_prices[cart.value];

  var start = new Date(rentalForm.elements["rental_start_time"].value);
  var end = new Date(rentalForm.elements["rental_end_time"].value);

  var date_range = Math.abs(end.getTime() - start.getTime());
  date_range = Math.ceil(date_range / (1000 * 3600 * 24));

  var item_type_daily_rate = item_type_daily_rates[cart.value];

  var price = item_type_price + (date_range*item_type_daily_rate)
  console.log(price);

  document.getElementById('rental_date_range').innerHTML = date_range;
  document.getElementById('rental_pricing').innerHTML = "$"+price;
}
