$(document).ready(function () {
  $("#multiUploadMoreFields").click(function () {
    if($(".multi-upload-group:visible").length === 0) {
      $(".multi-upload-group").show(); //we never deleted it, just hid it
    } else {
      $(".multi-upload-group").first().clone().appendTo("#multiUploadContainer"); //add new group

      //reset id's
      var num = $(".multi-upload-group").length;
      var group = $(".multi-upload-group").last(); //the grouping we just created

      var fileInput = group.find('.multi-upload-file'); //find file input in the group
      fileInput.attr("name",fileInput.attr("name").replace(/\d/,num)); //change the number in the id

      var descInput = group.find('.multi-upload-desc'); //find file desc in the group
      descInput.attr("name",descInput.attr("name").replace(/\d/,num)); //change the number in the id
    }
  });

  $(".multiUploadDeleteField").click(function () {
    if($(".multi-upload-group").length > 1) {
      $(this).parent().remove();
    } else {
      $(this).parent().hide(); //dont remove it, just hide it
    }
  });
});
