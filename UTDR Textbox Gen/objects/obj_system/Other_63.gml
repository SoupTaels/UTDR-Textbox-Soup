///@desc 
var async = async_load;
if ( async[? "id"] == customupload ) {
	var result = async[? "result"];
	if ( result != "" ) { show_message(result); }
	customupload = -1;
}