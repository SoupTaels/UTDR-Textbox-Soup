#region Macros
	#macro c_cyan rgb(0, 162, 232) //Undertale's cyan
	#macro c_gold rgb(221, 155, 32) //Gold color
	#macro c_deltarune rgb(21, 21, 102) //Deltarune's Blue Shadow
	
	#macro mouse_x_gui device_mouse_x_to_gui(0) //Draw GUI mouse x coord
	#macro mouse_y_gui device_mouse_y_to_gui(0) //Draw GUI mouse y coord
	#macro mouse_check device_mouse_check_button(0, mb_left)
	#macro mouse_pressed device_mouse_check_button_pressed(0, mb_left)
	#macro mouse_released device_mouse_check_button_released(0, mb_left)
#endregion ( also check __scribble_config_colours() )

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