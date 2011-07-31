$(document).ready(function() {
	$(".login-button").click(function() {
		$("#login-window").show();
		return false;
	});
	$("body .container").click(function() {
		$("#login-window").hide();
		return false;
	});
});
