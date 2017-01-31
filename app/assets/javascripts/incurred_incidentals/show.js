$(document).ready(function () {
  $(".image-expand-action").click(function (e) {
    e.preventDefault();
    var modal = $("#modalIncurredIncidentalDocument");
    modal.modal("toggle");
    var image = $(this).find("img").clone(); //get the image
    image.css(""); //strip the css which would make it a small image
    modal.find();
  });
});
