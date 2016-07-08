$(document).ready(function() {

	$('#calendar').fullCalendar({
		events : gon.reservations,
		eventClick: function(calEvent, jsEvent, view) {
			var win = window.open(calEvent.url, '_blank');
			win.focus();
		}
	})
});
