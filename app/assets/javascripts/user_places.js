var cur_row = 0;
var timeout = 10000;
var scroll_by = 15;
var scroll_time = 3000;
var timeout_handler;
function next_scroll() {
	if (cur_row < max_rows - scroll_by) {
		cur_row += scroll_by;
		$.scrollTo('#row-place-' + cur_row, scroll_time);
	}
	else {
		cur_row = 0;
		$.scrollTo('#wrapper', scroll_time);
	}
	timeout_handler = setTimeout('next_scroll();', timeout)
}

function adjust_uservoice_height() {
	var window_height = window.innerHeight;
	if (window.innerWidth < 1000) {
		$('#uservoice').css('height', '');
		return;
	}
	var header_height = $('#uservoice-wrapper .all-header').height();
	$('#uservoice').height(window_height - header_height);	
}

$(function() { 
	$('body').bind('click', function() {
		clearTimeout(timeout_handler);
	});
	if (is_tv) {
		timeout_handler = setTimeout('next_scroll();', timeout)
	}
	
	adjust_uservoice_height();

	$(window).on('resize', function(){
		adjust_uservoice_height();
	});
});