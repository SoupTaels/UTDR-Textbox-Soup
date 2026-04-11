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

enum DIRSCAN_DATA_TYPE {
	FULL_PATH,
	NAME_ONLY,
	FULL_INFO,
}
/// @desc Reads all files in a directory and subdirectories. Returns different types of data.
/// @param {string} pathSource The directory path.
/// @param {array} contentsArray The array to fill with contents.
/// @param {string} extension The file extension to search. Example: "*.png". Use *.* for every extension.
/// @param {bool} searchFiles Enable file search.
/// @param {bool} searchFolders Enable folder search.
/// @param {bool} searchSubdir Enable sub directory search.
/// @param {real} dataType Determines the type of date to be returned. Example: DIRSCAN_DATA_TYPE.NAME_ONLY.
/// @param {bool} getSize Get file sizes while scanning.
/// @param {bool} debug View debug messages.
/// @param {string} returnext The file extension to only return. Example: "*.png". Use *.* for every extension.
/// @returns {array} Array with contents.
function directory_get_contents(_pathSource, _contentsArray, _extension="*", _searchFiles=true, _searchFolders=true, _searchSubdir=true, _dataType=DIRSCAN_DATA_TYPE.FULL_PATH, _getSize=false, _debug=true, _returnext = -1) {
	// based on https://yal.cc/gamemaker-recursive-folder-copying/
	if (!directory_exists(_pathSource)) {
		return undefined;
	}
	// scan contents (folders and files)
	var _contents = [];
	var _file = file_find_first(_pathSource + "\\" + _extension, fa_directory | fa_archive | fa_readonly);
	var _filesCount = 0;
	while(_file != "") {
		if (_file == ".") continue;
		if (_file == "..") continue;
		array_push(_contents, _file);
		_file = file_find_next();
		_filesCount++;
	}
	file_find_close();
	// process found contents:
	var _i = 0;
	repeat(_filesCount) {
		var _fileName = _contents[_i];
		var _path = _pathSource + "\\" + _fileName; // the path of the content (folder or file)
		var _dirName = filename_dir_name(_path);
		var _data = undefined;
		var _progress = (_i / _filesCount); // ready-only
		if (_debug) show_debug_message($"Scanning: [{_progress * 100}%] {_dirName} | {_fileName}");
		if (directory_exists(_path)) {
			// recursively search directories
			if (_searchSubdir) directory_get_contents(_path, _contentsArray, _extension, _searchFiles, _searchFolders, _searchSubdir, _dataType, _getSize);
			if (_searchFolders) {
			switch(_dataType) {
				case DIRSCAN_DATA_TYPE.FULL_INFO:
					_data = {
						name : _fileName,
						type : 0,
						ext : "",
						path : _path,
						rootFolder : _dirName,
						size : -1,
					};
					break;
				case DIRSCAN_DATA_TYPE.NAME_ONLY: _data = _fileName; break;
				case DIRSCAN_DATA_TYPE.FULL_PATH: _data = _path; break;
				}
			}
		} else {
			if (_searchFiles) {
				switch(_dataType) {
					case DIRSCAN_DATA_TYPE.FULL_INFO:
						_data = {
							name : filename_name_noext(_fileName),
							type : 1,
							ext : filename_ext(_fileName),
							path : _path,
							rootFolder : _dirName,
							size : _getSize ? bytes_get_size(file_get_size(_path)) : -1,
						};
						break;
					case DIRSCAN_DATA_TYPE.NAME_ONLY: _data = _fileName; break;
					case DIRSCAN_DATA_TYPE.FULL_PATH: _data = _path; break;
				}
			}
		}
		if (_data != undefined ) {
			if ( _returnext == -1 ) { array_push(_contentsArray, _data); }
			else { if ( filename_ext(_data) == _returnext ) { array_push(_contentsArray, _data); } }
		}
		++_i;
	}
    return _contents;
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
		if (_char == "\\") {
		_dirName = string_copy(_dir, i + 1, string_length(_dir) - i);
		break;
	}
		--i;
	}
	return _dirName;
}

/// @desc Get file name, without extension.
/// @param {string} file File path.
/// @returns {string} 
function filename_name_noext(_path) {
	return filename_name(filename_change_ext(_path, ""));
}

/// @desc Load a file and get the size in bytes.
/// @param {string} file File path.
/// @returns {real} 
function file_get_size(_file) {
	var _buff = buffer_load(_file);
	if (_buff <= 0) return 0;
	var _size = buffer_get_size(_buff);
	buffer_delete(_buff);
	return _size;
}

/// @desc Convert bytes to KB, MB, GB, etc.
/// @param {real} bytes File bytes amount.
/// @returns {string} 
function bytes_get_size(_bytes) {
	static _sizes = ["B", "KB", "MB", "GB", "TB", "PB"]; // you can add more
	if (_bytes <= 0) return "0 B";
	var i = floor(log2(_bytes) / log2(1024));
	return string(round(_bytes / power(1024, i))) + " " + _sizes[i];
}

///@desc Same as draw_sprite_ext(), but will make sure if the sprite exists. Otherwise, draw nothing. Useful for external sprites
function draw_sprite_ensure(sprite, subimg = 0, xx = x, yy = y, xscale = 1, yscale = 1, rot = 0, color = c_white, alpha = 1) {
	var spr_ = is_string(sprite) ? asset_get_index(sprite) : sprite;
	if ( spr_ != -1 ) { draw_sprite_ext(spr_, subimg, xx, yy, xscale, yscale, rot, color, alpha); } else { show_debug_message($"\"{sprite}\" doesn't exist!"); }
}