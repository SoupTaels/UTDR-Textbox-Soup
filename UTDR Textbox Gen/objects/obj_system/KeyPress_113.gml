///@desc Debug
room_restart();
/*
if ( game_is_compiled() ) { //If we're not running the game from the IDE
	var params = "";
	var count = parameter_count();
	for ( var i = 0; i < count; i++; ) { params += parameter_string(i) + " "; }
	game_change(".", params);
}
else {
	var params = [], final = "";
	var count = parameter_count();
	for ( var i = 0; i < count; i++; ) { params[i] = parameter_string(i) + " "; }
	params[2] = $"\"{params[2]}\"";
	array_delete(params, 0, 1);
	for ( var i = 0; i < array_length(params); i++; ) { final += params[i]; }
	game_change(".", final);
}