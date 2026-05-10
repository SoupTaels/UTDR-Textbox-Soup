outputLog = "";
#region Add External Faces
	faces_dict = {};
	faces_dict_alt = {};
	
	var findfaces = gumshoe("faces", ".png"), faces_i = 0, faces_count = 0, faces_len = array_length(findfaces), _is_microsoft = ( os_type == os_windows || os_type == os_xboxseriesxs || os_type == os_gdk ), _path_separator = _is_microsoft? "\\"  :  "/";
	repeat ( faces_len ) {
		var faces_cur = findfaces[faces_i]; //Current face we're looking at
		var faces_dir = filename_dir_name(faces_cur); //Get directory name
		if ( !struct_exists(global.faces_dict, faces_dir) ) { global.faces_dict[$ faces_dir] = {}; } //Create new struct face dictionary
			var temp_ = string_replace(faces_cur, $"faces{_path_separator}{faces_dir}{_path_separator}", ""); //Remove faces/(folder name)/
			var imgnum = string_between(temp_, "_strip", ".png"); imgnum = imgnum == "" ? 1 : real(imgnum); //Get the image number if it's a strip file
			var faces_emote = string_exclude(string_replace(string_replace(string_replace(temp_, $"_strip", ""), $"spr_{faces_dir}_", ""), ".png", ""), "1234567890"); //Get face expression
			
			with ( global.faces_dict[$ faces_dir] ) {
				self[$ faces_emote] = { sprite: sprite_add(faces_cur, imgnum, false, false, 0, 0), expression: faces_emote, name: faces_cur, count: imgnum, } //Add sprite index and expression name to the global face dictonary
				with ( self[$ faces_emote] ) { 
					self[$ "destroy"] = function () { sprite_delete(sprite); delete sprite; sprite = -1; show_debug_message($"External face \"{name}\" was destroyed and freed from memory successfully!"); } //Add a destroy func so we don't get memory leaks
					sprite_set_offset(sprite, sprite_get_width(sprite)/ 2, sprite_get_height(sprite)/ 2); //Center sprite
					
					var scrib_ = $"{faces_dir}_{expression}"; scribble_external_sprite_add(sprite, scrib_); //Register sprite with Scribble
					var altname_ = $"spr_{scrib_}"; if ( !scribble_external_sprite_exists(altname_) ) { scribble_external_sprite_add(sprite, altname_); } //Alternative name
					global.faces_dict_alt[$ altname_] = { sprite, name: altname_, destroy } //Add sprite index and expression name to the global face alt dictonary
					var out_ = $"Added \"{expression}\" from {name}! | Image number: {count} | Scribble name: {scrib_} | Scribble alt name: {altname_}";
					show_debug_message(out_); global.outputLog += $"{out_}\n";
					faces_count++;
				}
			}
	faces_i++; }
	var out_ = $"Over {faces_count} external faces were loaded!";
	show_debug_message(out_); global.outputLog += $"{out_}\n";
	
	///@desc Returns a sprite index from an externally added face sprite.
	///@param {string} name Character Name or Expression Name
	///@param {string} expression Expression type
	///@param {string} return_ What to return
	function get_face(name, expression = -1, return_ = "sprite") {
		/*
			var result = get_face("alphys", "depressed sorry");
			show_debug_message(result);

			var result = get_face("alphys depressed sorry");
			show_debug_message(result);

			var result = get_face("spr_alphys_depressed_sorry");
			show_debug_message(result);

			var result = get_face("alphys", "depressed_sorry");
			show_debug_message(result);

			var result = get_face("alphys_depressed_sorry");
			show_debug_message(result);
		*/
		if ( expression == -1 ) { //Just proving a name, probably using the quick way to get a sprite
			var getface = global.faces_dict_alt[$ name], getfacespr = global.faces_dict_alt[$ $"spr_{name}"], name2 = string_replace_all(name, " ", "_"), getfacespr2 = global.faces_dict_alt[$ $"spr_{name2}"];
			return getface != undefined ? getface[$ return_] : ( getfacespr != undefined ? getfacespr[$ return_] : ( getfacespr2 != undefined ? getfacespr2[$ return_] : -1 ) );
		}
		else { //Providing a face name and expression
			var getface = global.faces_dict[$ name];
			if ( getface != undefined ) {
				var exp_ =  getface[$ expression], getexp = string_replace_all(expression, " ", "_"), exp_2 =  getface[$ getexp];
				return exp_ != undefined ? exp_[$ return_] : ( exp_2 != undefined ? exp_2[$ return_] : -1 );
			}
		}
	}
#endregion

#region Add Borders, Icons, and Reference Image
	#region Icons
		icons_dict = {};
		icons_dict_alt = {};
	
		var findicons = gumshoe("icons", ".png"), icons_i = 0, icons_len = array_length(findicons), _is_microsoft = ( os_type == os_windows || os_type == os_xboxseriesxs || os_type == os_gdk ), _path_separator = _is_microsoft? "\\"  :  "/";
		repeat ( icons_len ) {
			var icons_cur = findicons[icons_i]; //Current icon we're looking at
		
			var temp_ = string_replace(icons_cur, $"icons{_path_separator}", ""); 
			var imgnum = string_between(temp_, "_strip", ".png"); imgnum = imgnum == "" ? 1 : real(imgnum); //Get the image number if it's a strip file
			temp_ = string_replace(string_replace(string_replace(temp_, $"spr_", ""), $"_strip", ""), $".png", "");
			temp_ = string_exclude(temp_, "0123456789");
		
			icons_dict[$ temp_] = { sprite: sprite_add(icons_cur, imgnum, false, false, 0, 0), name: temp_, fname_: icons_cur, count: imgnum, }
			with ( icons_dict[$ temp_] ) {
				self[$ "destroy"] = function () { sprite_delete(sprite); delete sprite; sprite = -1; show_debug_message($"External icon \"{fname_}\"({name}) was destroyed and freed from memory successfully!"); } //Add a destroy func so we don't get memory leaks
				sprite_set_offset(sprite, sprite_get_width(sprite)/ 2, sprite_get_height(sprite)/ 2); //Center sprite
				
				var out_ = $"Added \"{name}\" from {fname_}! Image Count: {count}";
				scribble_external_sprite_add(sprite, name);
				
				var temp_2 = string_replace(icons_cur, $"icons{_path_separator}", ""); 
				temp_2 = string_replace(string_replace(temp_2, $"_strip", ""), $".png", "");
				temp_2 = string_exclude(temp_2, "0123456789");
				if ( !scribble_external_sprite_exists(temp_2) ) { scribble_external_sprite_add(sprite, temp_2); } //alternative
				global.icons_dict_alt[$ temp_2] = { sprite, name, } //Add sprite index and expression name to the global icon alt dictonary
				show_debug_message(out_); global.outputLog += $"{out_}\n";
			}
		icons_i++; }
		
		///@desc Returns a sprite index from an externally added icon sprite.
		///@param {string} name Icon Sprite Name (ex: soupcan, spr_dw_tv_time_its, funnytext amazing, etc.)
		function get_icon(name, return_ = "sprite") { 
			var result = global.icons_dict[$ name], result2 = global.icons_dict_alt[$ name];
			var temp_ = string_replace_all(name, " ", "_"), result3 = global.icons_dict[$ temp_]
			return !is_undefined(result) ? result[$ return_] : ( !is_undefined(result2) ? result2[$ return_] : ( !is_undefined(result3) ? result3[$ return_] : -1 ) );
		}
	#endregion
	
	#region Borders
		bords_dict = {};
		bords_dict_alt = {};
	
		var findbords = gumshoe("borders", ".png"), bords_i = 0, bords_len = array_length(findbords), _is_microsoft = ( os_type == os_windows || os_type == os_xboxseriesxs || os_type == os_gdk ), _path_separator = _is_microsoft? "\\"  :  "/";
		repeat ( bords_len ) {
			var bords_cur = findbords[bords_i]; //Current border we're looking at
		
			var temp_ = string_replace(bords_cur, $"borders{_path_separator}", ""); 
			var imgnum = string_between(temp_, "_strip", ".png"); imgnum = imgnum == "" ? 1 : real(imgnum); //Get the image number if it's a strip file
			temp_ = string_replace(string_replace(string_replace(temp_, $"spr_", ""), $"_strip", ""), $".png", "");
			temp_ = string_exclude(temp_, "0123456789");
		
			bords_dict[$ temp_] = { sprite: sprite_add(bords_cur, imgnum, false, false, 0, 0), name: temp_, fname_: bords_cur, count: imgnum, }
			with ( bords_dict[$ temp_] ) {
				self[$ "destroy"] = function () { sprite_delete(sprite); delete sprite; sprite = -1; show_debug_message($"External border \"{fname_}\"({name}) was destroyed and freed from memory successfully!"); } //Add a destroy func so we don't get memory leaks
				sprite_set_offset(sprite, sprite_get_width(sprite)/ 2, sprite_get_height(sprite)/ 2); //Center sprite
				
				var out_ = $"Added \"{name}\" from {fname_}! | Image Count: {count}";
				var temp_2 = string_replace(bords_cur, $"borders{_path_separator}", ""); 
				temp_2 = string_replace(string_replace(temp_2, $"_strip", ""), $".png", "");
				temp_2 = string_exclude(temp_2, "0123456789");
				global.bords_dict_alt[$ temp_2] = { sprite, name, } //Add sprite index and expression name to the global icon alt dictonary
				show_debug_message(out_); global.outputLog += $"{out_}\n";
			}
		bords_i++; }
		
		///@desc Returns a sprite index from an externally added border sprite.
		///@param {string} name Border Sprite Name (ex: spr_border_custom_animated, border custom example, border_custom_example_two, etc.)
		function get_border(name, return_ = "sprite") { 
			var result = global.bords_dict[$ name], result2 = global.bords_dict_alt[$ name];
			var temp_ = string_replace_all(name, " ", "_"), result3 = global.bords_dict[$ temp_]
			return !is_undefined(result) ? result[$ return_] : ( !is_undefined(result2) ? result2[$ return_] : ( !is_undefined(result3) ? result3[$ return_] : -1 ) );
		}
	#endregion
	
	#region Reference Image
		var _is_microsoft = ( os_type == os_windows || os_type == os_xboxseriesxs || os_type == os_gdk ), _path_separator = _is_microsoft? "\\"  :  "/", fname = $"reference{_path_separator}reference_image.png", fnamedebug = string_replace(fname, $"reference{_path_separator}", "");
		global.refimg = -1; if ( file_exists(fname) ) { global.refimg = sprite_add_ext(fname, 1, 0, 0, true); show_debug_message($"Added \"{fnamedebug}\" from {fname}!"); }
	#endregion
#endregion

#region Add Custom Fonts
	fonts_dict = {};
	fonts_dict_alt = {};
	
	var findfonts = gumshoe("fonts", ".png"), fonts_i = 0, fonts_len = array_length(findfonts), _is_microsoft = ( os_type == os_windows || os_type == os_xboxseriesxs || os_type == os_gdk ), _path_separator = _is_microsoft? "\\"  :  "/";
	repeat ( fonts_len ) {
		var fonts_cur = findfonts[fonts_i]; //Current font we're looking at
		
		var temp_ = string_replace(fonts_cur, $"fonts{_path_separator}", ""); 
		var imgnum = string_between(temp_, "_strip", ".png"); imgnum = imgnum == "" ? 1 : real(imgnum); //Get the image number if it's a strip file
		temp_ = string_replace(string_replace(string_replace(temp_, $"spr_", ""), $"_strip", ""), $".png", "");
		temp_ = string_exclude(temp_, "0123456789");
		
		fonts_dict[$ temp_] = { sprite: sprite_add(fonts_cur, imgnum, false, false, 0, 0), name: temp_, fname_: fonts_cur, count: imgnum, }
		with ( fonts_dict[$ temp_] ) {
			self[$ "font"] = font_add_sprite(sprite, ord("!"), false, 0); //Add as an actual font
			self[$ "destroy"] = function () { sprite_delete(sprite); delete sprite; sprite = -1; font_delete(font); delete font; font = -1; show_debug_message($"External font \"{fname_}\"({name}) was destroyed and freed from memory successfully!"); } //Add a destroy func so we don't get memory leaks
			
			var temp_2 = string_replace(fonts_cur, $"fonts{_path_separator}", ""); 
			temp_2 = string_replace(string_replace(temp_2, $"_strip", ""), $".png", "");
			temp_2 = string_exclude(temp_2, "0123456789");
	
			global.fonts_dict_alt[$ temp_2] = { sprite, font, name, } //Add sprite index and expression name to the global icon alt dictonary
			var getfont = asset_get_name(sprite);
			scribble_font_rename(getfont, name); //Let us use the font's filename instead of whatever name gamemaker generated for us
			scribble_font_bake_outline_and_shadow(name, $"{name}_outline", 0, 0, SCRIBBLE_OUTLINE.EIGHT_DIR, 0, false);
			scribble_glyph_set($"{name}_outline", all, SCRIBBLE_GLYPH.FONT_HEIGHT, scribble_glyph_get(name, "W", SCRIBBLE_GLYPH.FONT_HEIGHT));
			var out_ = $"Added \"{name}\" and outline variant from {fname_}! Renamed custom font from {getfont} to {global.fonts_dict_alt[$ temp_2].name} for use with Scribble.\nImage Count: {count}";
			show_debug_message(out_); global.outputLog += $"{out_}\n";
		}
	fonts_i++; }
	
	///@desc Returns a sprite index from an externally added font sprite.
	///@param {string} name Font Sprite Name (ex: spr_font_custom_example, font custom example two, etc.)
	function get_font(name, return_ = "font") { 
		var result = global.fonts_dict[$ name], result2 = global.fonts_dict_alt[$ name];
		var temp_ = string_replace_all(name, " ", "_"), result3 = global.fonts_dict[$ temp_]
		return !is_undefined(result) ? result[$ return_] : ( !is_undefined(result2) ? result2[$ return_] : ( !is_undefined(result3) ? result3[$ return_] : -1 ) );
	}
#endregion

var oLog = file_text_open_write($"{executable_get_directory()}latest_soupy_run.txt");
file_text_write_string(oLog, global.outputLog);
file_text_close(oLog);