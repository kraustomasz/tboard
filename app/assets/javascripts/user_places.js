var cur_row = 0;
var timeout = 10000;
var scroll_by = 15;
var scroll_time = 1000;
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

$(function() { 
	$('body').bind('click', function() {
		clearTimeout(timeout_handler);
	});
	timeout_handler = setTimeout('next_scroll();', timeout)


});