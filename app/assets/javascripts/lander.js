$(document).ready(function() {
	$(".login-button").click(function() {
		$("#login-window").show();
		return false;
	});
	$("body").click(function() {
		$("#login-window").hide();
		return false;
	});
});
