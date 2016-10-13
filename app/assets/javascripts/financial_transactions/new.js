$(document).ready(function() {
  $('#contact_email').change(function (){
    var email_regex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/i;
    if(!email_regex.test($('#contact_email').val()))
      $('#contact_email').parent().parent().addClass('has-error');
    else 
      $('#contact_email').parent().parent().removeClass('has-error');
  });

  $('#contact_phone').change(function (){
    var email_regex = /^[0-9]{10}$/i;
    if(!email_regex.test($('#contact_phone').val()))
      $('#contact_phone').parent().parent().addClass('has-error');
    else 
      $('#contact_phone').parent().parent().removeClass('has-error');
  });
});
