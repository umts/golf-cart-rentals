$(document).ready(function() {

	$('#calendar').fullCalendar({
		events : gon.reservations,
		timeFormat: ' ',
		eventClick: function(calEvent, jsEvent, view) {
			var win = window.open(calEvent.url, '_blank');
			win.focus();
		}
	})
});
