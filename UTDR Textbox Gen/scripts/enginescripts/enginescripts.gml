randomize();

#region Macros
	#macro c_cyan rgb(0, 162, 232) //Undertale's cyan
	#macro c_gold rgb(221, 155, 32) //Gold color
	#macro c_deltarune rgb(21, 21, 102) //Deltarune's Blue Shadow
	
	#macro mouse_x_gui device_mouse_x_to_gui(0) //Draw GUI mouse x coord
	#macro mouse_y_gui device_mouse_y_to_gui(0) //Draw GUI mouse y coord
	#macro mouse_check device_mouse_check_button(0, mb_left)
	#macro mouse_pressed device_mouse_check_button_pressed(0, mb_left)
	#macro mouse_released device_mouse_check_button_released(0, mb_left)
	#macro mouse_check_right device_mouse_check_button(0, mb_right)
	#macro mouse_pressed_right device_mouse_check_button_pressed(0, mb_right)
	#macro mouse_released_right device_mouse_check_button_released(0, mb_right)
	// flip this value to 0 to disable GMLive!
	#macro live_enabled 0
#endregion

///@desc Shorthand function for make_color_rgb,
function rgb(r_ = 255, g_ = 255, b_ = 255) { return make_color_rgb(r_, g_, b_); }

///@desc Debug function for seeing and getting mouse coords
function mouse_debug() 
{
	static debugA = 0.5;
	debugA = approach(debugA, ( range_within(mouse_x_gui, 0, 150) && range_within(mouse_y_gui, 0, 50) ) ? 1 : 0.5, 0.05); 
	draw_format(, , fnt_determination, c_yellow, debugA);
	draw_text(10, 10, $"Mouse GUI: ({mouse_x_gui}, {mouse_y_gui})\nMouse Room: ({mouse_x}, {mouse_y})\nFPS: {fps}\nFPS REAL: {fps_real}");

	static doublepress = 0; doublepress = approach(doublepress, 0, 1);
	if ( keyboard_check_pressed(vk_tab) ) {
		if ( doublepress == 0 ) { doublepress = 15; }
		else { doublepress = 0; clipboard_set_text(!keyboard_check(ord("Q")) ? $"{mouse_x_gui}, {mouse_y_gui}" : $"{mouse_x}, {mouse_y}"); }
	}
	draw_format();
}

///@desc Sets up default drawing parameters
function draw_format(halign = -1, valign = -1, font = -1, color = c_white, alpha = 1)
{
	var halign_, valign_;
	switch ( halign ) {
		case "left": case fa_left: { halign_ = fa_left; } break;
		case "right": case fa_right: { halign_ = fa_right; } break;
		case "center": case fa_center: { halign_ = fa_center; } break;
		default: { halign_ = -1; }
	}
	switch ( valign ) {
		case "top": case "up": case fa_top: { valign_ = fa_top; } break;
		case "bottom": case "down": case fa_bottom: { valign_ = fa_bottom; } break;
		case "center": case fa_middle: { valign_ = fa_middle; } break;
		default: { valign_ = -1; }
	}
	
	draw_set_alpha(alpha);
	draw_set_color(color);
	draw_set_font(font);
	draw_set_halign(halign_);
	draw_set_valign(valign_);
}

///@desc Shifts a value linearly over time.
///@param {real} start_ Start value
///@param {real} end_ End value
///@param {real} shift_ Amount to shift the value
function approach(start_, end_, shift_) { return start_ < end_ ? min(start_ + shift_, end_) : max(start_ - shift_, end_); }

///@desc Checks whether the specified variable's value is between two values.
///Example: range_within(mouse_x, 0, 150) will return a boolean of whether mouse_x is between 0 and 150.
///@arg {real} value Variable
///@arg {real} startv Range Min
///@arg {real} endv Range Max
function range_within(value, startv, endv) { return ( value >= startv && value <= endv ); }

///@desc Returns a boolean (true or false) indicating whether the game was exported as a standalone (executable).
///@returns {bool} 
function game_is_compiled() {
	static fromIDE = undefined;
	if ( !is_undefined(fromIDE) ) { return fromIDE; }
	
	fromIDE = ( GM_build_type == "exe" );
	return fromIDE;
}

///@desc Unified way to get the name of any asset
///@param {string|asset} _asset Asset
function asset_get_name(_asset) {
	var _type = asset_get_type(_asset);
	switch ( _type ) {
		case asset_object:							return object_get_name(_asset);
		case asset_sprite:								return sprite_get_name(_asset);
		case asset_sound:							return audio_get_name(_asset);
		case asset_room:								return room_get_name(_asset);
		case asset_tiles:									return tileset_get_name(_asset);
		case asset_path:								return path_get_name(_asset);
		case asset_script:								return script_get_name(_asset);
		case asset_font:								return font_get_name(_asset);
		case asset_timeline:							return timeline_get_name(_asset);
		case asset_shader:							return shader_get_name(_asset);
		case asset_animationcurve:			return animcurve_get(_asset).name;
		case asset_sequence:						return sequence_get(_asset).name;
		case asset_particlesystem:			return particle_get_info(_asset).name;
		case asset_unknown: default:		return undefined;
	}
}
	
///@desc Returns an array of calculated center-aligned positions based on the size and amount given.
///@param {real} size_ Size of the items
///@param {real} amt_ Amount of items to calculate
///@param {real} center_ Center position for the items
///@param {real} off_ Offset separation between items
/*
	EX:
	var s_ = spr_player_soul, w_ = sprite_get_width(s_), h_ = sprite_get_height(s_), count_ = 3, xx_ = 320, yy_ = 240, sep_ = 6;
	var c_coords = centerizer(w_, count_, xx_, sep_);
	var c_coords2 = centerizer(h_, count_, yy_, sep_);

	for ( var i = 0; i < count_; i++; ) {
		draw_sprite_ext(s_, 0, xx_, c_coords2[i] + sin(current_time/1000 ) * 5, 1, 1, 0, c_ltgray, 1);
		draw_sprite(s_, 0, c_coords[i], yy_);
	}

	draw_circle_color(320, 240, 1, c_red, c_red, false);
*/
function centerizer(size_ = 1, amt_ = 2, center_ = 0, off_ = 1) {
	var i = 0, arr_ = array_create(amt_), total_size = ( ( size_ + off_ ) * amt_ ) - off_;
	if ( amt_ <= 1 ) { arr_[0] = center_; return arr_; }
	
	repeat ( amt_ ) {
		var result = ( center_ - ( total_size/ 2 ) ) + ( ( ( size_ + off_ ) * i ) + ( size_/ 2 ) );
		arr_[i] = result;
		i++;
	}
	
	return arr_;
}
	
///@desc Frees a Data Structure if it exists.
///@param {any} ds_ Data Structure
///@param {any} type_ Data Structure type
///@param {function} func_ Optional function to run if successfully cleared
function ds_free(ds_, type_, func_ = function () {})
{
	if ( !ds_exists(ds_, type_) ) { show_debug_message($"Data structure {ds_} doesn't exist."); }
	
	switch ( type_ ) {
		case ds_type_grid: { ds_grid_destroy(ds_); } break;
		case ds_type_list: { ds_list_destroy(ds_); } break;
		case ds_type_map: { ds_map_destroy(ds_); } break;
		case ds_type_priority: { ds_priority_destroy(ds_); } break;
		case ds_type_queue: { ds_queue_destroy(ds_); } break;
		case ds_type_stack: { ds_stack_destroy(ds_); } break;
	}
		
	func_();
}

///@desc Takes the current value and remaps it from one range to another range. (ex: health bars, menu sliders, damage scaling, etc.)
///@param {real} value_ Current Value
///@param {real} min1_ Old Range Min
///@param {real} max1_ Old Range Max
///@param {real} min2_ New Range Min
///@param {real} max2_ New Range Max
/*
	example use:
	var hpcalc = map_value(current_player_hp, min_player_hp, max_player_hp, draw_hp_x_min, draw_hp_x_max);
	draw_rectangle(x1, x2, hpcalc, y2);
*/
function map_value(value_, min1_, max1_, min2_, max2_) { return ( ( ( value_ - min1_ ) / ( max1_ - min1_ ) ) * ( max2_ - min2_ ) ) + min2_; }

///@desc Checks whether the given string contains the substring or not. Always returns false for an empty substringg.
///@arg {String} str_					The string to find the substring in.
///@arg {String} substr_				The string to check.
///@arg {Bool} casesense_		Whether the string is case sensitive.
function string_search(str_ = "", substr_ = "", casesense_ = false) {
	if ( substr_ == "" || str_ == "" ) { return false; }
	return ( string_pos(substr_, !casesense_ ? string_lower(str_) : str_) > 0 );
}

/// @desc Get directory name from a file.
/// @param {string} file File path.
/// @returns {string} 
function filename_dir_name(_file) {
	// var _dirName = filename_name(filename_dir(file));
	var _dir = filename_dir(_file), _dirName = "";
	var isize = string_length(_dir), i = isize;
	repeat(isize) {
		var _char = string_char_at(_dir, i);
		if ( _char == PATHSEP ) {
		_dirName = string_copy(_dir, i + 1, string_length(_dir) - i);
		break;
	}
		--i;
	}
	return _dirName;
}

///@desc Same as draw_sprite_ext(), but will make sure if the sprite exists. Otherwise, draw nothing. Useful for external sprites
function draw_sprite_ensure(sprite, subimg = 0, xx = x, yy = y, xscale = 1, yscale = xscale, rot = 0, color = c_white, alpha = 1) {
	var spr_ = is_string(sprite) ? asset_get_index(sprite) : sprite;
	if ( spr_ != -1 ) { draw_sprite_ext(spr_, subimg, xx, yy, xscale, yscale, rot, color, alpha); } else { show_debug_message($"\"{sprite}\" doesn't exist!"); }
}

function draw_nineslice(sprite_, x1, y1, x2, y2, color = c_white, alpha = 1, index = 0) {
	var left = x1;
	var top = y1;
	var right = x2;
	var bottom = y2;
	var sprite = sprite_;
	var tint = color;
	var opacity = alpha;

	if (!sprite_exists(sprite)) return false;

	// Vett Sprite

	var sprite_size = sprite_get_height(sprite);

	if (sprite_get_width(sprite) != sprite_size)
	{
	    show_debug_message(sprite_get_name(sprite) + " cannot be NINEBOXed because it is not a perfect square.");
	    return false;
	}
	if not (sprite_size mod 3 == 0)
	{
	    show_debug_message(sprite_get_name(sprite) + " cannot be NINEBOXed because its pixel size is not divisible by three.");
	    return false;
	}
	var slice_size = sprite_size / 3;

	// Draw Fill

	var scale_x = ((right - slice_size) - (left + slice_size)) / slice_size;
	var scale_y = ((bottom - slice_size) - (top + slice_size)) / slice_size;
	draw_sprite_part_ext(sprite, index, slice_size, slice_size, slice_size, slice_size, left + slice_size, top + slice_size, scale_x, scale_y, tint, opacity);

	// Draw Vertical Edges

	draw_sprite_part_ext(sprite, index, 0, slice_size, slice_size, slice_size, left, top + slice_size, 1, scale_y, tint, opacity);
	draw_sprite_part_ext(sprite, index, slice_size * 2, slice_size, slice_size, slice_size, right - slice_size, top + slice_size, 1, scale_y, tint, opacity);

	// Draw Horizontal Edges

	draw_sprite_part_ext(sprite, index, slice_size, 0, slice_size, slice_size, left + slice_size, top, scale_x, 1, tint, opacity);
	draw_sprite_part_ext(sprite, index, slice_size, slice_size * 2, slice_size, slice_size, left + slice_size, bottom - slice_size, scale_x, 1, tint, opacity);

	// Draw the Corners

	draw_sprite_part_ext(sprite, index, 0, 0, slice_size, slice_size, left, top, 1, 1, tint, opacity);
	draw_sprite_part_ext(sprite, index, slice_size * 2, 0, slice_size, slice_size, right - slice_size, top, 1, 1, tint, opacity);
	draw_sprite_part_ext(sprite, index, 0, slice_size * 2, slice_size, slice_size, left, bottom - slice_size, 1, 1, tint, opacity);
	draw_sprite_part_ext(sprite, index, slice_size * 2, slice_size * 2, slice_size, slice_size, right - slice_size, bottom - slice_size, 1, 1, tint, opacity);

	return slice_size;
}

///@desc Uses a pretty cheap and ineffecient way to give sprites an outline.
function draw_sprite_outline(sprite_ = sprite_index, index_ = image_index, x_ = x, y_ = y, thickness_ = 1, xscale_ = image_xscale, yscale_ = image_yscale, angle_ = image_angle, color_ = c_black, blend_ = c_white, alpha_ = image_alpha, self_ = true) {
	if ( sprite_exists(sprite_) ) {
		gpu_set_fog(true, color_, 0, 0); //Draw solid color of sprite
		draw_sprite_ext(sprite_, index_, x_ + thickness_, y_, xscale_, yscale_, angle_, c_white, alpha_); //up
		draw_sprite_ext(sprite_, index_, x_ - thickness_, y_, xscale_, yscale_, angle_, c_white, alpha_); //down
		draw_sprite_ext(sprite_, index_, x_ , y_ + thickness_, xscale_, yscale_, angle_, c_white, alpha_); //left
		draw_sprite_ext(sprite_, index_, x_ , y_ - thickness_, xscale_, yscale_, angle_, c_white, alpha_); //right

		draw_sprite_ext(sprite_, index_, x_ + thickness_, y_ + thickness_, xscale_, yscale_, angle_, c_white, alpha_); //downright
		draw_sprite_ext(sprite_, index_, x_ - thickness_, y_ + thickness_, xscale_, yscale_, angle_, c_white, alpha_); //downleft
		draw_sprite_ext(sprite_, index_, x_ + thickness_, y_ - thickness_, xscale_, yscale_, angle_, c_white, alpha_); //upright
		draw_sprite_ext(sprite_, index_, x_ - thickness_, y_ - thickness_, xscale_, yscale_, angle_, c_white, alpha_); //upleft
		gpu_set_fog(false, c_white, 0, 0); //Reset effect
	}
	
	if ( self_ ) { draw_sprite_ext(sprite_, index_, x_, y_, xscale_, yscale_, angle_, blend_, alpha_); }
}

///@desc Shorthand for audio_play_sound()
function sfx_play(snd, loop = false, gain = 0.7, pitch = 1) { if ( global.pref.killaudio || snd == -1 || snd == undefined ) { exit; } return audio_play_sound(snd, 0, loop, gain, , pitch); }

///@desc Removes anything that isn't a number or decimal point
function string_digits_ext(str){
	var result  = ""; 
	for ( var i = 1, len = string_length(str); i <= len; i++; ) {
		var nextOrd = string_ord_at(str, i);
		if ( ( nextOrd >= 48 && nextOrd <= 57 ) || nextOrd == 46 || nextOrd == 45 ) { result += chr(nextOrd); }
	}
    
	return result;
}

///@desc Remove every other decimal points but the first.
function first_decimal(string_) {
	for ( var i = 1, len = string_length(string_); i < len; i++; ) {
		var char = string_char_at(string_, i);
		if ( char == "." ) {
			for ( var j = i + 1; j < len; j++; ) { if ( string_char_at(string_, j) == "." ) { string_ = string_delete(string_, j, len); } } //An additional "." is found
		}
	}
	
	var decs = string_count(".", string_); //If there's still some decimals, trim them off
	if ( decs > 1 ) { string_ = string_delete(string_, len, decs - 1); }
	return string_;
}

///@desc Returns a valid real number with anything that isn't a number stripped out. This also keeps the first decimal point. If no numbers were found, this will return "" instead.
function real_ext(string_) {
	string_ = string_digits_ext(string_);
	string_ = first_decimal(string_);
	try { string_ = real(string_); } catch ( err_ ) { string_ = string_digits(string_); }
	return ( string_digits(string_) != "" ) ? real(string_) : "";
}

///@desc Makes a copy of a string, but excluding characters in a character exclusion string. Optionally can replace those characters with another character.
///@param {string} string_ String
///@param {string} exclude_ All characters to look for in a string.
///@param {string} sub_ Substitute replaced characters with specified string
function string_exclude(string_, exclude_, sub_ = "") {
	for ( var i = 1, len = string_length(string_) + 1, str = string_; i < len; i++; ) {
		var char_ = string_char_at(string_, i)
		for ( var ex_i = 1, ex_len = string_length(exclude_) + 1, ex_char_ = ""; ex_i < ex_len; ex_i++; ) {
			ex_char_ = string_char_at(exclude_, ex_i);
			if ( char_ == ex_char_ ) { str = string_replace_all(str, ex_char_, sub_); }
		}
	}
	return str;
}
	
///@desc delta_time optimizer
function deltaizer() { return delta_time * game_get_speed(gamespeed_fps) * 0.000001; }

///@desc Returns a copy of the string found between two substrings.
///@param {string} str String to search through
///@param {string} substr1 Start substring
///@param {string} substr2 End substring
///@param {real} skip Skip the first nth substr1 (optional argument, default 0)
///@param {real} startfrom Start from the nth character (optional argument, default 1)
function string_between(str, substr1, substr2, skip = 0, startfrom = 1) {
	var first_found = false, str_between = "", times_found = 0, str_length = string_length(str), substr1_length = string_length(substr1), substr2_length = string_length(substr2);
	for ( var i = startfrom; i < str_length; i++; ) {
		if ( !first_found ) {
			if ( string_ord_at(str, i) == string_ord_at(substr1, 1) ) {
				for ( var s = 0, same_chars = true; s < substr1_length-1; s++; ) {
					same_chars = string_ord_at(str, i + s) == string_ord_at(substr1, s + 1);
					if ( !same_chars ) { break; }
				}
				if ( same_chars ) { if ( times_found++ == skip ) { first_found = true; i += substr1_length-1; } }
			}
		}
		else {    
			if ( string_ord_at(str, i) == string_ord_at(substr2, 1) ) {
				for ( var s = 0, same_chars = true; s < substr2_length - 1; s++; ) {
					same_chars = string_ord_at(str, i + s) == string_ord_at(substr2, s + 1);
					if ( !same_chars ) { break; }
				}
				if ( same_chars ) { return str_between; }
			}
			str_between += string_char_at(str, i);
		}
	}
    
	if ( first_found ) { str_between += string_char_at(str, i); }
	return str_between;
}

///@desc Returns a copy of the string found between two string positions.
///@param {string} str String to search through
///@param {real} start_ Start substring
///@param {real} end_ End substring
function string_copy_at(str, start_, end_) {
	var correct_ = start_ < end_;
	return string_copy(str, correct_ ? start_ : end_,  correct_ ? ( end_ - start_ ) : ( start_ - end_ ));
}

///@desc Returns a copy of the string without the string found between the two string positions.
///@param {string} str String to search through
///@param {real} start_ Start substring
///@param {real} end_ End substring
function string_delete_at(str, start_, end_) {
	var correct_ = start_ < end_;
	return string_delete(str, correct_ ? start_ : end_,  correct_ ? ( end_ - start_ ) : ( start_ - end_ ));
}

///@desc Checks if the specified variable exists and returns it, otherwise return a default value
///@param {string} name_ Variable name
///@param {any} default_ Default value to provide if this doesn't exist
function ensure_value(var_, default_) {
	return !is_undefined(var_) ? var_ : default_;
}

/// @desc Capitalize the first letter of the string
/// @param {string} str Text string.
/// @returns {string} 
function string_upper_first(_str) {
	var _string = string_lower(_str),
	_strFinal = "",
	i = 1, isize = string_length(_str);
	repeat(isize) {
		var _char = string_char_at(_string, i);
		_strFinal += (i == 1) ? string_upper(_char) : _char;
		++i;
	}
	return _strFinal;
}

///@desc Game restarting using game_change
function game_restart_alt() {
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
}

///@desc Makes code run based on an on and off timer
///@param {real} offTime When code doesn't run
///@param {real} onTime When code runs
///@param {real} phaseShift Timer offset
///@param {real} clock Timer (default: current_time(milliseconds))
function blink(offTime = 500, onTime = offTime, phaseShift = 0, clock = current_time) { return ( clock + phaseShift ) mod ( offTime + onTime ) >= offTime; }