$(document).ready(function () {
  $(".image-expand-action").click(function (e) {
    e.preventDefault();
    var modal = $("#modalIncurredIncidentalDocument");
    modal.modal("toggle"); //open modal

    var image = $(this).find("img").clone(); //get the image
    image.css(""); //strip the css which would make it a small image
    var doc = $(this).parent().parent(); //find entire document element
    var desc = doc.find(".document-description").html().trim(); //get description from document

    modal.find(".modal-title").html(desc); //write the desc into the modal title
  });
});
