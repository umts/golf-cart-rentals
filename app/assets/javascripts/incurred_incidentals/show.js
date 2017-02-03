$(document).ready(function () {
  $(".image-expand-action").click(function (e) {
    e.preventDefault();
    var modal = $("#modalIncurredIncidentalDocument");
    modal.modal("toggle"); //open modal

    var image = $(this).find("img").clone(); //get the image
    image.removeClass(); //strip the old classes off, they will format the image to be very small
    image.addClass("large-picture"); //change the css class
    var doc = $(this).parent().parent(); //find entire document element
    var desc = doc.find(".document-description").html().trim(); //get description from document

    modal.find(".modal-title").html(desc); //write the desc into the modal title
    modal.find(".modal-body").html(image); //over write body placing image into it
  });
});
