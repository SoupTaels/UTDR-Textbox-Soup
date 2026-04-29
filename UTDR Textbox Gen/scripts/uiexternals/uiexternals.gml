outputLog = "";
#region Add External Faces
	faces_dict = {};
	faces_dict_alt = {};
	
	var findfaces = gumshoe("faces", ".png"), faces_i = 0, faces_len = array_length(findfaces), _is_microsoft = ( os_type == os_windows || os_type == os_xboxseriesxs || os_type == os_gdk ), _path_separator = _is_microsoft? "\\"  :  "/";
	repeat ( faces_len ) {
		var faces_cur = findfaces[faces_i]; //Current face we're looking at
		var faces_dir = filename_dir_name(faces_cur); //Get directory name
		if ( !struct_exists(global.faces_dict, faces_dir) ) { global.faces_dict[$ faces_dir] = {}; } //Create new struct face dictionary
	
		var temp_ = string_replace(faces_cur, $"faces{_path_separator}{faces_dir}{_path_separator}", ""); //Remove faces/(folder name)/
		temp_ = string_replace(string_replace(string_replace(temp_, "_strip", ""), ".png", ""), "spr_", ""); //Remove .png, _strip, and spr_
		var temp2 = string_digits(temp_), imgnum = temp2 != "" ? real(temp2) : 1; //Get how many numbers are in this strip image
		temp_ = string_letters(temp_); //Remove anything that isn't a letter
		var faces_emote = string_replace(temp_, faces_dir, ""); //Get face expression
	
		with ( global.faces_dict[$ faces_dir] ) {
			self[$ faces_emote] = { sprite: sprite_add(faces_cur, imgnum, false, false, 0, 0), expression: faces_emote, name: faces_cur, } //Add sprite index and expression name to the global face dictonary
			with ( self[$ faces_emote] ) { 
				self[$ "destroy"] = function () { sprite_delete(sprite); delete sprite; sprite = -1; show_debug_message($"External face \"{name}\" was destroyed and freed from memory successfully!"); } //Add a destroy func so we don't get memory leaks
				sprite_set_offset(sprite, sprite_get_width(sprite)/ 2, sprite_get_height(sprite)/ 2); //Center sprite
			}
			var out_ = $"Added \"{self[$ faces_emote].expression}\" from {self[$ faces_emote].name}!";
			scribble_external_sprite_add(self[$ faces_emote].sprite, $"{faces_dir}_{self[$ faces_emote].expression}");
			
			var temp_2 = string_replace(faces_cur, $"faces{_path_separator}{faces_dir}{_path_separator}", ""); //Remove faces/(folder name)/
			temp_2 = string_replace(string_replace(temp_2, "_strip", ""), ".png", ""); //Remove .png and _strip.
			temp_2 = string_exclude(temp_2, "0123456789");
			if ( !scribble_external_sprite_exists(temp_2) ) { scribble_external_sprite_add(self[$ faces_emote].sprite, temp_2); } //alternative
			
			global.faces_dict_alt[$ temp_2] = { sprite: self[$ faces_emote].sprite, name: temp_2 } //Add sprite index and expression name to the global face alt dictonary
			show_debug_message(out_); global.outputLog += $"{out_}\n";
		}
		faces_i++;
	}
	
	///@desc Returns a sprite index from an externally added face sprite.
	///@param {string} name Character Name or Expression Name (ex: alphys, toriel, asgore, or alphys_depressedsorry, undyne_pissed, etc.)
	///@param {string} expression Expression type
	function get_face(name, expression = -1) {
		var face = -1, has__ = string_search(name, "_", false);
		if ( has__ ) { 
			var count = string_count("_", name);
			
			if ( count == 1 ) {
				var sep = string_split(name, "_"); 
				if ( !struct_exists(global.faces_dict, sep[0])) { face = -1; return face; } 
				with ( global.faces_dict[$ sep[0]] ) { if ( !struct_exists(self, sep[1])) { face = -1; return face; }  face = self[$ sep[1]].sprite; }
			}
			else {
				if ( !struct_exists(global.faces_dict_alt, name)) { face = -1; return face; } 
				with ( global.faces_dict_alt[$ name] ) { face = self.sprite; }
			}
		} 
		else {
			if ( !struct_exists(global.faces_dict, name)) { face = -1; return face; } 
			with ( global.faces_dict[$ name] ) { if ( !struct_exists(self, expression)) { face = -1; return face; } face = self[$ expression].sprite; } }
		return face;
	}
	
	///@desc Returns the name of a face expression from an externally added face sprite.
	///@param {string} name Character Name or Expression Name (ex: alphys, toriel, asgore, or alphys_depressedsorry, undyne_pissed, etc.)
	///@param {string} expression Expression type
	function get_face_name(name, expression) {
		var face = -1, has__ = string_search(name, "_", false);
		if ( has__ ) { var sep = string_split(name, "_"); with ( global.faces_dict[$ sep[0]] ) { face = self[$ sep[1]].expression; } } else	{ with ( global.faces_dict[$ name] ) { face = self[$ expression].expression; } }
		return face;
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
			temp_ = string_replace(string_replace(string_replace(temp_, $"spr_", ""), $"_strip", ""), $".png", "");
			var getnum = string_digits(temp_), imgnum = getnum != "" ? real(getnum) : 1;
			temp_ = string_letters(temp_);
		
			icons_dict[$ temp_] = { sprite: sprite_add(icons_cur, imgnum, false, false, 0, 0), name: temp_, fname: icons_cur }
			with ( icons_dict[$ temp_] ) {
				self[$ "destroy"] = function () { sprite_delete(sprite); delete sprite; sprite = -1; show_debug_message($"External icon \"{fname}\"({name}) was destroyed and freed from memory successfully!"); } //Add a destroy func so we don't get memory leaks
				sprite_set_offset(sprite, sprite_get_width(sprite)/ 2, sprite_get_height(sprite)/ 2); //Center sprite
			}
			var out_ = $"Added \"{icons_dict[$ temp_].name}\" from {icons_dict[$ temp_].fname}!";
			scribble_external_sprite_add(icons_dict[$ temp_].sprite, icons_dict[$ temp_].name);
			
			var temp_2 = string_replace(icons_cur, $"icons{_path_separator}", ""); 
			temp_2 = string_replace(string_replace(temp_2, $"_strip", ""), $".png", "");
			temp_2 = string_exclude(temp_2, "0123456789");
			if ( !scribble_external_sprite_exists(temp_2) ) { scribble_external_sprite_add(global.icons_dict[$ temp_].sprite, temp_2); } //alternative
			global.icons_dict_alt[$ temp_2] = { sprite: global.icons_dict[$ temp_].sprite, name: temp_2 } //Add sprite index and expression name to the global icon alt dictonary
			show_debug_message(out_); global.outputLog += $"{out_}\n";
		icons_i++; }
		
		///@desc Returns a sprite index from an externally added icon sprite.
		///@param {string} name Icon Sprite Name (ex: soupcan, battlebuttons, battlechars, etc.)
		function get_icon(name) { return struct_exists(global.icons_dict, name) ? global.icons_dict[$ name].sprite : ( struct_exists(global.icons_dict_alt, name) ? global.icons_dict_alt[$ name].sprite : -1 ); }
		
		///@desc Returns a struct from an externally added icon sprite.
		///@param {string} name Icon Sprite Name (ex: soupcan, battlebuttons, battlechars, etc.)
		function get_icon_data(name) { return struct_exists(global.icons_dict, name) ? global.icons_dict[$ name] : ( struct_exists(global.icons_dict_alt, name) ? global.icons_dict_alt[$ name] : -1 ); }
	#endregion
	
	#region Borders
		bords_dict = {};
		bords_dict_alt = {};
	
		var findbords = gumshoe("borders", ".png"), bords_i = 0, bords_len = array_length(findbords), _is_microsoft = ( os_type == os_windows || os_type == os_xboxseriesxs || os_type == os_gdk ), _path_separator = _is_microsoft? "\\"  :  "/";
		repeat ( bords_len ) {
			var bords_cur = findbords[bords_i]; //Current border we're looking at
		
			var temp_ = string_replace(bords_cur, $"borders{_path_separator}", ""); 
			temp_ = string_replace(string_replace(string_replace(temp_, $"spr_", ""), $"_strip", ""), $".png", "");
			var getnum = string_digits(temp_), imgnum = getnum != "" ? real(getnum) : 1;
			temp_ = string_letters(temp_);
		
			bords_dict[$ temp_] = { sprite: sprite_add(bords_cur, imgnum, false, false, 0, 0), name: temp_, fname: bords_cur }
			with ( bords_dict[$ temp_] ) {
				self[$ "destroy"] = function () { sprite_delete(sprite); delete sprite; sprite = -1; show_debug_message($"External border \"{fname}\"({name}) was destroyed and freed from memory successfully!"); } //Add a destroy func so we don't get memory leaks
				sprite_set_offset(sprite, sprite_get_width(sprite)/ 2, sprite_get_height(sprite)/ 2); //Center sprite
			}
			var out_ = $"Added \"{bords_dict[$ temp_].name}\" from {bords_dict[$ temp_].fname}!";
			
			var temp_2 = string_replace(bords_cur, $"borders{_path_separator}", ""); 
			temp_2 = string_replace(string_replace(temp_2, $"_strip", ""), $".png", "");
			temp_2 = string_exclude(temp_2, "0123456789");
			if ( !scribble_external_sprite_exists(temp_2) ) { scribble_external_sprite_add(global.bords_dict[$ temp_].sprite, temp_2); } //alternative
			global.bords_dict_alt[$ temp_2] = { sprite: global.bords_dict[$ temp_].sprite, name: temp_2 } //Add sprite index and expression name to the global icon alt dictonary
			show_debug_message(out_); global.outputLog += $"{out_}\n";
		bords_i++; }
		
		///@desc Returns a sprite index from an externally added border sprite.
		///@param {string} name Border Sprite Name (ex: bordercustomexample, bordercustomexampletwo, etc.)
		function get_border(name) { return struct_exists(global.bords_dict, name) ? global.bords_dict[$ name].sprite : ( struct_exists(global.bords_dict_alt, name) ? global.bords_dict_alt[$ name].sprite : -1 ); }
		
		///@desc Returns a struct from an externally added border sprite.
		///@param {string} name Border Sprite Name (ex: bordercustomexample, bordercustomexampletwo, etc.)
		function get_border_data(name) { return struct_exists(global.bords_dict, name) ? global.bords_dict[$ name] : ( struct_exists(global.bords_dict_alt, name) ? global.bords_dict_alt[$ name] : -1 ); }
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
		temp_ = string_replace(string_replace(string_replace(temp_, $"spr_", ""), $"_strip", ""), $".png", "");
		var getnum = string_digits(temp_), imgnum = getnum != "" ? real(getnum) : 1;
		temp_ = string_letters(temp_);
		
		fonts_dict[$ temp_] = { sprite: sprite_add(fonts_cur, imgnum, false, false, 0, 0), name: temp_, fname: fonts_cur }
		with ( fonts_dict[$ temp_] ) {
			self[$ "font"] = font_add_sprite(sprite, ord("!"), false, 0); //Add as an actual font
			self[$ "destroy"] = function () { sprite_delete(sprite); delete sprite; sprite = -1; font_delete(font); delete font; font = -1; show_debug_message($"External font \"{fname}\"({name}) was destroyed and freed from memory successfully!"); } //Add a destroy func so we don't get memory leaks
			sprite_set_offset(sprite, sprite_get_width(sprite)/ 2, sprite_get_height(sprite)/ 2); //Center sprite
		}
		
		var temp_2 = string_replace(fonts_cur, $"fonts{_path_separator}", ""); 
		temp_2 = string_replace(string_replace(temp_2, $"_strip", ""), $".png", "");
		temp_2 = string_exclude(temp_2, "0123456789");
	
		global.fonts_dict_alt[$ temp_2] = { sprite: global.fonts_dict[$ temp_].sprite, font: global.fonts_dict[$ temp_].font, name: temp_2 } //Add sprite index and expression name to the global icon alt dictonary
		var getfont = asset_get_name(fonts_dict[$ temp_].sprite);
		scribble_font_rename(getfont, global.fonts_dict_alt[$ temp_2].name); //Let us use the font's filename instead of whatever name gamemaker generated for us
		scribble_font_duplicate(global.fonts_dict_alt[$ temp_2].name, global.fonts_dict[$ temp_].name); //Also let us use the quick name version
		var out_ = $"Added \"{fonts_dict[$ temp_].name}\" from {fonts_dict[$ temp_].fname}! Renamed custom font from {getfont} to {global.fonts_dict_alt[$ temp_2].name} for use with Scribble.";
		show_debug_message(out_); global.outputLog += $"{out_}\n";
	fonts_i++; }
	
	///@desc Returns a sprite index from an externally added font sprite.
	///@param {string} name Font Sprite Name (ex: spr_font_custom_example, fontcustomexample)
	function get_font(name) { return struct_exists(global.fonts_dict, name) ? global.fonts_dict[$ name].font : ( struct_exists(global.fonts_dict_alt, name) ? global.fonts_dict_alt[$ name].font : -1 ); }
		
	///@desc Returns a struct from an externally added font sprite.
	///@param {string} name Font Sprite Name (ex: spr_font_custom_example, fontcustomexample)
	function get_font_data(name) { return struct_exists(global.fonts_dict, name) ? global.fonts_dict[$ name] : ( struct_exists(global.fonts_dict_alt, name) ? global.fonts_dict_alt[$ name] : -1 ); }
#endregion

//var _is_microsoft = ( os_type == os_windows || os_type == os_xboxseriesxs || os_type == os_gdk ), _path_separator = _is_microsoft? "\\"  :  "/";
//var oLog = file_text_open_write($"{program_directory}{_path_separator}external_database_log.txt");
//file_text_write_string(oLog, global.outputLog);
//file_text_close(oLog);