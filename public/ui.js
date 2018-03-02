/* Adds a red asterix next to required fields */
$(function(){
  $("[required]").each(function(index, element){
    $(element).parent().addClass("required");
    $(element).parents("form").addClass("with-required");
  });
});
