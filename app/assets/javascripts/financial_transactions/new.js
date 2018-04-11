$(document).ready(function() {
  $('#contact_email').change(function (){
    var email_regex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/i;
    if(!email_regex.test($('#contact_email').val()))
      $('#contact_email').parent().parent().addClass('has-error');
    else
      $('#contact_email').parent().parent().removeClass('has-error');
  });
});
