outputLog = "";
outputLogSkipped = "";
pref = {
	firsttime: true, //Whether it's the first time this tool has been launched
	shadowoff: 1, //Text shadow offset
	killaudio: false, //Whether the tool should make sound
	sizematters: false, //Whether the tool should export dialogue with a resolution of 640x480
	sizematterstop: false, //Whether to send the dialogue box to the top
	anyborder: false, //Whether to allow any arbitrary border
	hidemessages: false, //Whether to hide output sucess message
	checkupdates: true, //Check for updates?
	parsestart: global.altchar.start_, //Start alt command 
	parseend: global.altchar.end_, //End alt command 
	showref: true, //Whether to show the reference image on export
}
#region Add External Faces
	faces_dict = {};
	faces_dict_alt = {};
	
	var findfaces = gumshoe("faces", ".png"), faces_i = 0, faces_count = 0, faces_len = array_length(findfaces);
	repeat ( faces_len ) {
		var faces_cur = findfaces[faces_i]; //Current face path we're looking at
		var faces_dir = filename_dir_name(faces_cur); //Get directory name
		if ( faces_dir != "" ) { //Not trying to load a file outside a folder
			if ( !struct_exists(global.faces_dict, faces_dir) ) { global.faces_dict[$ faces_dir] = {}; } //Create new struct face dictionary
			var temp_ = string_replace(faces_cur, $"faces{PATHSEP}{faces_dir}{PATHSEP}", ""); //Remove faces/(folder name)/
			var imgnum = string_between(temp_, "_strip", ".png"); imgnum = imgnum == "" ? 1 : real(imgnum); //Get the image number if it's a strip file
			var faces_emote = string_exclude(string_replace(string_replace(string_replace(temp_, $"_strip", ""), $"spr_{faces_dir}_", ""), ".png", ""), "1234567890"); //Get face expression
			if ( faces_emote != "" ) { //Filename isn't just numbers
				with ( global.faces_dict[$ faces_dir] ) {
					if ( is_undefined(self[$ faces_emote]) ) { //If this dictonary doesn't already exist
					self[$ faces_emote] = { sprite: sprite_add(faces_cur, imgnum, false, false, 0, 0), expression: faces_emote, name: faces_cur, count: imgnum, } //Add sprite index and expression name to the global face dictonary
						with ( self[$ faces_emote] ) { 
							self[$ "destroy"] = function () { sprite_delete(sprite); delete sprite; sprite = -1; show_debug_message($"External face \"{name}\" was destroyed and freed from memory successfully!"); } //Add a destroy func so we don't get memory leaks
							self[$ "size"] = { sprite, width: sprite_get_width(sprite), height: sprite_get_height(sprite), }
							sprite_set_offset(sprite, size.width/ 2, size.height/ 2); //Center sprite
					
							var scrib_ = $"{faces_dir}_{expression}"; scribble_external_sprite_add(sprite, scrib_); //Register sprite with Scribble
							var altname_ = $"spr_{scrib_}"; if ( !scribble_external_sprite_exists(altname_) ) { scribble_external_sprite_add(sprite, altname_); } //Alternative name
							global.faces_dict_alt[$ altname_] = { sprite, name: altname_, destroy, size } //Add sprite index and expression name to the global face alt dictonary
							var out_ = $"Added \"{expression}\" from {name}! | Image number: {count} | Scribble name: {scrib_} | Scribble alt name: {altname_}";
							show_debug_message(out_); global.outputLog += $"{out_}\n";
							faces_count++;
						}
					}
					else { 
						var out_ = $"Tried to load a sprite that already exists({faces_cur})! Skipping..."; 
						show_debug_message(out_); global.outputLog += $"{out_}\n"; 
				
						var out_ = $"|Tried to load a sprite that already exists|({faces_cur})! Skipped...|Remove duplicates before trying again!|"; 
						global.outputLogSkipped += out_; 
					}
				}
			}
			else { 
				var out_ = $"Tried to load a sprite with an invalid name({faces_cur})! Skipping..."; 
				show_debug_message(out_); global.outputLog += $"{out_}\n"; 
				
				var out_ = $"|Tried to load a sprite with an invalid filename|({faces_cur})! Skipped...|Make sure you properly name your files! (No numbers besides _stripN.png)|"; 
				global.outputLogSkipped += out_; 
			}
		}
		else { 
			var out_ = $"Tried to load a sprite outside of a folder({faces_cur})! Skipping..."; 
			show_debug_message(out_); global.outputLog += $"{out_}\n"; 
				
			var out_ = $"|Tried to load a sprite outside of a folder|({faces_cur})! Skipped...|Face sprites for auto-loading should have all their faces in their own folders!|"; 
			global.outputLogSkipped += out_; 
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
		var early_ = asset_get_index(name);
		if ( early_ != -1 ) { return early_; }
		if ( expression == -1 || string_letters(expression) == "" ) { //Just proving a name, probably using the quick way to get a sprite
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
	
		var findicons = gumshoe("icons", ".png"), icons_i = 0, icons_len = array_length(findicons);
		repeat ( icons_len ) {
			var icons_cur = findicons[icons_i]; //Current icon we're looking at
		
			var temp_ = string_replace(icons_cur, $"icons{PATHSEP}", ""); 
			var imgnum = string_between(temp_, "_strip", ".png"); imgnum = imgnum == "" ? 1 : real(imgnum); //Get the image number if it's a strip file
			temp_ = string_replace(string_replace(string_replace(temp_, $"spr_", ""), $"_strip", ""), $".png", "");
			temp_ = string_exclude(temp_, "0123456789");
			if ( temp_ != "" ) {
				if ( is_undefined(icons_dict[$ temp_]) ) {
					icons_dict[$ temp_] = { sprite: sprite_add(icons_cur, imgnum, false, false, 0, 0), name: temp_, fname_: icons_cur, count: imgnum, }
					with ( icons_dict[$ temp_] ) {
						self[$ "destroy"] = function () { sprite_delete(sprite); delete sprite; sprite = -1; show_debug_message($"External icon \"{fname_}\"({name}) was destroyed and freed from memory successfully!"); } //Add a destroy func so we don't get memory leaks
						self[$ "size"] = { sprite, width: sprite_get_width(sprite), height: sprite_get_height(sprite), }
						sprite_set_offset(sprite, size.width/ 2, size.height/ 2); //Center sprite
				
						var out_ = $"Added \"{name}\" from {fname_}! Image Count: {count}";
						scribble_external_sprite_add(sprite, name);
				
						var temp_2 = string_replace(icons_cur, $"icons{PATHSEP}", ""); 
						temp_2 = string_replace(string_replace(temp_2, $"_strip", ""), $".png", "");
						temp_2 = string_exclude(temp_2, "0123456789");
						if ( !scribble_external_sprite_exists(temp_2) ) { scribble_external_sprite_add(sprite, temp_2); } //alternative
						global.icons_dict_alt[$ temp_2] = { sprite, name, size, } //Add sprite index and expression name to the global icon alt dictonary
						show_debug_message(out_); global.outputLog += $"{out_}\n";
					}
				}
				else { 
					var out_ = $"Tried to load a sprite that already exists({icons_cur})! Skipping..."; 
					show_debug_message(out_); global.outputLog += $"{out_}\n"; 
				
					var out_ = $"|Tried to load a sprite that already exists|({icons_cur})! Skipped...|Remove duplicates before trying again!|"; 
					global.outputLogSkipped += out_; 
				}
			}
			else { 
				var out_ = $"Tried to load a sprite with an invalid name({icons_cur})! Skipping..."; 
				show_debug_message(out_); global.outputLog += $"{out_}\n"; 
				
				var out_ = $"|Tried to load a sprite with an invalid filename|({icons_cur})! Skipped...|Make sure you properly name your files! (No numbers besides _stripN.png)|"; 
				global.outputLogSkipped += out_; 
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
		bords_dict_raw = {};
	
		var findbords = gumshoe("borders", ".png"), bords_i = 0, bords_len = array_length(findbords);
		repeat ( bords_len ) {
			var bords_cur = findbords[bords_i]; //Current border we're looking at
		
			var temp_ = string_replace(bords_cur, $"borders{PATHSEP}", ""); 
			var imgnum = string_between(temp_, "_strip", ".png"); imgnum = imgnum == "" ? 1 : real(imgnum); //Get the image number if it's a strip file
			temp_ = string_replace(string_replace(string_replace(temp_, $"spr_", ""), $"_strip", ""), $".png", "");
			temp_ = string_exclude(temp_, "0123456789");
		
			if ( temp_ != "" ) {
				if ( is_undefined(bords_dict[$ temp_]) ) {
					bords_dict[$ temp_] = { sprite: sprite_add(bords_cur, imgnum, false, false, 0, 0), name: temp_, fname_: bords_cur, count: imgnum, }
					with ( bords_dict[$ temp_] ) {
						self[$ "destroy"] = function () { sprite_delete(sprite); delete sprite; sprite = -1; show_debug_message($"External border \"{fname_}\"({name}) was destroyed and freed from memory successfully!"); } //Add a destroy func so we don't get memory leaks
						self[$ "size"] = { sprite, width: sprite_get_width(sprite), height: sprite_get_height(sprite), }
						//sprite_set_offset(sprite, size.width/ 2, size.height/ 2); //Center sprite
						asset_add_tags(sprite, "borders", asset_sprite);
				
						var out_ = $"Added \"{name}\" from {fname_}! | Image Count: {count}";
						var temp_2 = string_replace(bords_cur, $"borders{PATHSEP}", ""); 
						temp_2 = string_replace(string_replace(temp_2, $"_strip", ""), $".png", "");
						temp_2 = string_exclude(temp_2, "0123456789");
						global.bords_dict_alt[$ temp_2] = { sprite, name, size, } //Add sprite index and expression name to the global border alt dictonary
						global.bords_dict_raw[$ string(sprite)] = { sprite, name, size, } //Add sprite index and expression name to the global border raw dictonary
						show_debug_message(out_); global.outputLog += $"{out_}\n";
					}
				}
				else { 
					var out_ = $"Tried to load a sprite that already exists({bords_cur})! Skipping..."; 
					show_debug_message(out_); global.outputLog += $"{out_}\n"; 
				
					var out_ = $"|Tried to load a sprite that already exists|({bords_cur})! Skipped...|Remove duplicates before trying again!|"; 
					global.outputLogSkipped += out_; 
				}
			}
			else { 
				var out_ = $"Tried to load a sprite with an invalid name({bords_cur})! Skipping..."; 
				show_debug_message(out_); global.outputLog += $"{out_}\n"; 
				
				var out_ = $"|Tried to load a sprite with an invalid filename|({bords_cur})! Skipped...|Make sure you properly name your files! (No numbers besides _stripN.png)|"; 
				global.outputLogSkipped += out_; 
			}
		bords_i++; }
		
		///@desc Returns a sprite index from an externally added border sprite.
		///@param {string} name Border Sprite Name (ex: spr_border_custom_animated, border custom example, border_custom_example_two, etc.)
		function get_border(name, return_ = "sprite") { 
			var early_ = asset_get_index(name); if ( early_ != -1 ) { return !is_undefined(global.bords_dict_raw[$ name]) ? global.bords_dict_raw[$ name][$ return_] : early_; }
			var result = global.bords_dict[$ name], result2 = global.bords_dict_alt[$ name], result4 = global.bords_dict_raw[$ name];
			var temp_ = string_replace_all(name, " ", "_"), result3 = global.bords_dict[$ temp_]
			return !is_undefined(result) ? result[$ return_] : ( !is_undefined(result2) ? result2[$ return_] : ( !is_undefined(result3) ? result3[$ return_] : -1 ) );
		}
	#endregion
	
	#region Reference Image
		var fname = $"reference{PATHSEP}reference_image.png", fnamedebug = string_replace(fname, $"reference{PATHSEP}", "");
		global.refimg = -1; if ( file_exists(fname) ) { global.refimg = sprite_add_ext(fname, 1, 0, 0, true); show_debug_message($"Added \"{fnamedebug}\" from {fname}!"); }
	#endregion
#endregion

#region Add Custom Fonts
	fonts_dict = {};
	fonts_dict_alt = {};
	fonts_dict_list = [];
	fonts_dict_list_custom = [];
	
	#region Add built-in fonts to a list
		var fonts_ = tag_get_assets("fonts"), fonts_len = array_length(fonts_), fonts_i = 0;
		repeat ( fonts_len ) {
			var cur_ = fonts_[fonts_i];
			fonts_dict_list[fonts_i] = cur_;
		fonts_i++; }
	#endregion
	
	var findfonts = gumshoe("fonts", ".png"), fonts_i = 0, fonts_len = array_length(findfonts);
	repeat ( fonts_len ) {
		var fonts_cur = findfonts[fonts_i]; //Current font we're looking at
		
		var temp_ = string_replace(fonts_cur, $"fonts{PATHSEP}", ""); 
		var imgnum = string_between(temp_, "_strip", ".png"); imgnum = imgnum == "" ? 1 : real(imgnum); //Get the image number if it's a strip file
		temp_ = string_replace(string_replace(string_replace(temp_, $"spr_", ""), $"_strip", ""), $".png", "");
		temp_ = string_exclude(temp_, "0123456789");
		
		if ( temp_ != "" ) {
			if ( is_undefined(fonts_dict[$ temp_]) ) { 
				fonts_dict[$ temp_] = { sprite: sprite_add(fonts_cur, imgnum, false, false, 0, 0), name: temp_, fname_: fonts_cur, count: imgnum, }
				with ( fonts_dict[$ temp_] ) {
					array_push(global.fonts_dict_list, name); //Add custom font to array list
					array_push(global.fonts_dict_list_custom, name); //Add custom font to custom array list
					self[$ "font"] = font_add_sprite(sprite, ord("!"), false, 0); //Add as an actual font
					self[$ "destroy"] = function () { sprite_delete(sprite); delete sprite; sprite = -1; font_delete(font); delete font; font = -1; show_debug_message($"External font \"{fname_}\"({name}) was destroyed and freed from memory successfully!"); } //Add a destroy func so we don't get memory leaks
					
					var temp_2 = string_replace(fonts_cur, $"fonts{PATHSEP}", ""); 
					temp_2 = string_replace(string_replace(temp_2, $"_strip", ""), $".png", "");
					temp_2 = string_exclude(temp_2, "0123456789");
	
					global.fonts_dict_alt[$ temp_2] = { sprite, font, name, } //Add sprite index and expression name to the global icon alt dictonary
					var getfont = asset_get_name(sprite);
					scribble_font_rename(getfont, name); //Let us use the font's filename instead of whatever name gamemaker generated for us
					scribble_font_bake_outline_and_shadow(name, $"{name}_s", global.pref.shadowoff, global.pref.shadowoff, SCRIBBLE_OUTLINE.NO_OUTLINE, 0, false);
					scribble_font_bake_outline_and_shadow(name, $"{name}_outline", global.pref.shadowoff, global.pref.shadowoff, SCRIBBLE_OUTLINE.EIGHT_DIR, 0, false);
					scribble_font_delete(name); scribble_font_rename($"{name}_s", name);
					scribble_glyph_set($"{name}_outline", all, SCRIBBLE_GLYPH.FONT_HEIGHT, scribble_glyph_get(name, "W", SCRIBBLE_GLYPH.FONT_HEIGHT));
					var out_ = $"Added \"{name}\" and outline variant from {fname_}! Renamed custom font from {getfont} to {global.fonts_dict_alt[$ temp_2].name} for use with Scribble.\nImage Count: {count}";
					show_debug_message(out_); global.outputLog += $"{out_}\n";
				}
			}
			else { 
				var out_ = $"Tried to load a sprite that already exists({fonts_cur})! Skipping..."; 
				show_debug_message(out_); global.outputLog += $"{out_}\n"; 
				
				var out_ = $"|Tried to load a sprite that already exists|({fonts_cur})! Skipped...|Remove duplicates before trying again!|"; 
				global.outputLogSkipped += out_; 
			}
		}
		else { 
			var out_ = $"Tried to load a sprite with an invalid name({fonts_cur})! Skipping..."; 
			show_debug_message(out_); global.outputLog += $"{out_}\n"; 
				
			var out_ = $"|Tried to load a sprite with an invalid filename|({fonts_cur})! Skipped...|Make sure you properly name your files! (No numbers besides _stripN.png)|"; 
			global.outputLogSkipped += out_; 
		}
	fonts_i++; }
	
	///@desc Returns a sprite index from an externally added font sprite.
	///@param {string} name Font Sprite Name (ex: spr_font_custom_example, font custom example two, etc.)
	function get_font(name, return_ = "font") { 
		var early_ = asset_get_index(name); if ( early_ != -1 ) { return early_; }
		var result = global.fonts_dict[$ name], result2 = global.fonts_dict_alt[$ name];
		var temp_ = string_replace_all(name, " ", "_"), result3 = global.fonts_dict[$ temp_]
		return !is_undefined(result) ? result[$ return_] : ( !is_undefined(result2) ? result2[$ return_] : ( !is_undefined(result3) ? result3[$ return_] : -1 ) );
	}
#endregion

#region Log
	var oLog = file_text_open_write($"{executable_get_directory()}latest_soupy_run.soupy");
	file_text_write_string(oLog, global.outputLog);
	file_text_close(oLog);
#endregion

#region Functions
	///@desc Returns an external sprite or adds it if it doesn't already exist
	function external_ensure(name_, fname_, fpath_, type_ = 0, allowmultiple_ = true) {
		if ( filename_ext(fpath_) != ".png" ) { soupy_message($"\"{fname_}\"|is not allowed to be loaded.|File must be a PNG format.", , 320, , , snd_error, , , true); return -1; }
		
		switch ( type_ ) {
			case 0: { //Face Sprites
				var spr_ = get_face(name_);
				if ( spr_ != -1 ) { return spr_; } else {
					var imgnum = string_between(fname_, "_strip", ".png"); imgnum = imgnum == "" ? 1 : imgnum; //Get the image number if it's a strip file
					if ( name_ != "" ) {
						if ( !struct_exists(global.faces_dict, name_) ) { global.faces_dict[$ name_] = {}; } //Create new struct face dictionary
						with ( global.faces_dict[$ name_] ) {
							var finalname = string_replace(string_replace(fname_, "_strip", ""), ".png", ""); finalname = string_exclude(finalname, "0123456789");
							self[$ "NEW SPRITE"] = true; //Mark the sprite as new
							self[$ name_] = { sprite: sprite_add_ext(fpath_, imgnum, 0, 0, true), expression: finalname, name: fpath_, } //Add sprite and data
							if ( allowmultiple_ ) { TweenScript(SYSTEMUI, 0, 1, soup_store, "allowmultiple"); }
							with ( self[$ name_] ) { 
								self[$ "destroy"] = function () { sprite_delete(sprite); delete sprite; sprite = -1; show_debug_message($"External face \"{name}\" was destroyed and freed from memory successfully!"); } //Add a destroy func so we don't get memory leaks
							
								var out_ = $"Added \"{expression}\"|You can now use|[{expression}] and [face,{expression}]|to reference the sprite!|The command was copied to your clipboard.";
								TweenScript(SYSTEMUI, 0, 1, soup_store, "external face", { myname: name_, id_: name_, msg: out_}); 
								if ( !scribble_external_sprite_exists(finalname) ) { scribble_external_sprite_add(sprite, finalname); } //Add sprite to Scribble
								var altname = string_replace(finalname, "spr_", "");
								if ( !scribble_external_sprite_exists(altname) ) { scribble_external_sprite_add(sprite, altname); } //Add alternative name
								global.faces_dict_alt[$ name_] = { sprite, expression, name, destroy } //Create new struct face dictionary
								clipboard_set_text($"[{expression}][face,{expression}]");
								
								return sprite;
							}
						}
					}
					else { 
						TweenScript(SYSTEMUI, 0, 5, function (fpath_ = "") {
							var out_ = $"Tried to load a sprite with an invalid filename|({fpath_})! Skipped...|Make sure you properly name your files! (No numbers besides _stripN.png)";
							soupy_message(out_, "Oh no!", , 135, , snd_error, fnt_abaddon, function () { SYSTEMUI.file_dragging = false; }, SYSTEMUI.ui_paused);
						}, fpath_); return -1;
					}
				}
			} break;
			
			case 1: { //Border Sprites
				var spr_ = get_border(name_);
				if ( spr_ != -1 ) { return spr_; } else {
					if ( name_ != "" ) {
						if ( !struct_exists(global.bords_dict, name_) ) { global.bords_dict[$ name_] = {}; } //Create new struct border dictionary
						var imgnum = string_between(fname_, "_strip", ".png"); imgnum = imgnum == "" ? 1 : imgnum; //Get the image number if it's a strip file
						with ( global.bords_dict[$ name_] ) {
							var finalname = string_replace(string_replace(fname_, "_strip", ""), ".png", ""); finalname = string_exclude(finalname, "0123456789");

							self[$ "NEW SPRITE"] = true; //Mark the sprite as new
							self[$ "sprite"] = sprite_add_ext(fpath_, imgnum, 0, 0, true); self[$ "name"] = name_; self[$ "destroy"] = function () { sprite_delete(sprite); delete sprite; sprite = -1; show_debug_message($"External border \"{name}\" was destroyed and freed from memory successfully!"); } //Add a destroy func so we don't get memory leaks
							self[$ "size"] = { sprite, width: sprite_get_width(sprite), height: sprite_get_height(sprite), }
							asset_add_tags(sprite, "borders", asset_sprite);
							if ( allowmultiple_ ) { TweenScript(SYSTEMUI, 0, 1, soup_store, "allowmultiple"); }
							
							var out_ = $"Added \"{finalname}\"|You can now use|[border,{finalname}]|to reference the sprite!|The command was copied to your clipboard.";
							TweenScript(SYSTEMUI, 0, 1, soup_store, "external border", { myname: name_, msg: out_}); 
							global.bords_dict_alt[$ name_] = { sprite, name, size, } //Add sprite index and expression name to the global border alt dictonary
							global.bords_dict_raw[$ string(sprite)] = { sprite, name, size, } //Add sprite index and expression name to the global border raw dictonary
							clipboard_set_text($"[border,{finalname}]");
							return sprite;
						}
					}
					else { 
						TweenScript(SYSTEMUI, 0, 5, function (fpath_ = "") {
							var out_ = $"Tried to load a sprite with an invalid filename|({fpath_})! Skipped...|Make sure you properly name your files! (No numbers besides _stripN.png)";
							soupy_message(out_, "Oh no!", , 135, , snd_error, fnt_abaddon, function () { SYSTEMUI.file_dragging = false; }, SYSTEMUI.ui_paused);
						}, fpath_); return -1;
					}
				}
			} break;
			
			case 2: { //Font Sprites
				var spr_ = get_font(name_);
				if ( spr_ != -1 ) { return spr_; } else {
					if ( name_ != "" ) {
						if ( !struct_exists(global.fonts_dict, name_) ) { global.fonts_dict[$ name_] = {}; } //Create new struct font dictionary
						var imgnum = string_between(fname_, "_strip", ".png"); imgnum = imgnum == "" ? 1 : imgnum; //Get the image number if it's a strip file
						global.fonts_dict[$ name_] = { sprite: sprite_add(fpath_, imgnum, false, false, 0, 0), name: name_, fname_: filename_name(fpath_), count: imgnum, }
						with ( global.fonts_dict[$ name_] ) {
							self[$ "NEW SPRITE"] = true; self[$ "NEW EXTERNALLY"] = true;//Mark the sprite as new and added externally
							array_push(global.fonts_dict_list, name_); //Add custom font to array list
							array_push(global.fonts_dict_list_custom, name_); //Add custom font to array list
							self[$ "font"] = font_add_sprite(sprite, ord("!"), false, 0); //Add as an actual font
							self[$ "destroy"] = function () { sprite_delete(sprite); delete sprite; sprite = -1; font_delete(font); delete font; font = -1; show_debug_message($"External font \"{fname_}\"({name}) was destroyed and freed from memory successfully!"); } //Add a destroy func so we don't get memory leaks
							self[$ "size"] = { sprite, width: sprite_get_width(sprite), height: sprite_get_height(sprite), }
						
							global.fonts_dict_alt[$ name] = { sprite, font, name, } //Add sprite index and expression name to the global icon alt dictonary
							var getfont = asset_get_name(sprite);
						
							scribble_font_rename(getfont, name); //Let us use the font's filename instead of whatever name gamemaker generated for us
							scribble_font_bake_outline_and_shadow(name, $"{name}_s", global.pref.shadowoff, global.pref.shadowoff, SCRIBBLE_OUTLINE.NO_OUTLINE, 0, false);
							scribble_font_bake_outline_and_shadow(name, $"{name}_outline", global.pref.shadowoff, global.pref.shadowoff, SCRIBBLE_OUTLINE.EIGHT_DIR, 0, false);
							scribble_font_delete(name); scribble_font_rename($"{name}_s", name);
							scribble_glyph_set($"{name}_outline", all, SCRIBBLE_GLYPH.FONT_HEIGHT, scribble_glyph_get(name, "W", SCRIBBLE_GLYPH.FONT_HEIGHT));
							var out_ = $"Added \"{name}\"|You can now use|[{name}]|to reference the font!|The command was copied to your clipboard.";
							TweenScript(SYSTEMUI, 0, 2, soupy_message, out_, , , , , snd_sparkle2);
							clipboard_set_text($"[{name}]");
							return font;
						}
					}
					else { 
						TweenScript(SYSTEMUI, 0, 5, function (fpath_ = "") {
							var out_ = $"Tried to load a sprite with an invalid filename|({fpath_})! Skipped...|Make sure you properly name your files! (No numbers besides _stripN.png)";
							soupy_message(out_, "Oh no!", , 135, , snd_error, fnt_abaddon, function () { SYSTEMUI.file_dragging = false; }, SYSTEMUI.ui_paused);
						}, fpath_); return -1;
					}
				}
			} break;
		}
	}
	
	///@desc Function for choosing an externally added face
	//This code is a fucking mess of workarounds.
	function external_choose_face(multiple_ = false, inputsoup_ = "datainput", inputglobal_ = true, imagesoup_ = "dataimage", imageglobal_ = true, clear_ = true) {
		var options_ = [], options_names = struct_get_names(global.faces_dict), options_len = array_length(options_names), options_i = 0;
		repeat ( options_len ) { //Add available characters to an array
			var cur_ = options_names[options_i], isnew_ = global.faces_dict[$ cur_][$ "NEW SPRITE"];
			array_push(options_, 
				new LuiText({ value: isnew_ != undefined && isnew_ ? $"{string_upper_first(cur_)} (NEW!)" : string_upper_first(cur_), id_: cur_, font: fnt_speech, text_halign: fa_center, text_valign: fa_middle, color: ( get_face(cur_) != -1 ? c_cyan : c_white ), }).setPadding(5).setData("chara", cur_).setTooltip(get_face(cur_) != -1 ? $"[{cur_},0,0.15] [rainbow]Unique and recent!" : "", true, , true)
				.setData("inputsoup_", inputsoup_).setData("inputglobal_", inputglobal_).setData("imagesoup_", imagesoup_).setData("imageglobal_", imageglobal_).setData("clear_", clear_)
				.addEvent(LUI_EV_MOUSE_ENTER, function(element_) { element_.color = c_yellow; sfx_play(snd_sel_switch); element_.main_ui.animate(element_, "xoff", 10, 0.30, global.Ease.OutBack, 0); })
				.addEvent(LUI_EV_MOUSE_LEAVE, function(element_) { element_.color = get_face(element_.params.id_) != -1 ? c_cyan : c_white; element_.main_ui.animate(element_, "xoff", 0, 0.15); })
				.addEvent(LUI_EV_CLICK, function(element_) { //Once clicked on, create new scroll panel and populate it with face sprites
					var get_ = soup_checkout("scrollmain", false); soup_checkout("scrollsub", false).destroy(); 
					global.faces_dict[$ element_.params.id_][$ "NEW SPRITE"] = false; sfx_play(snd_select);
					//Exit early if the sprite already exists(for external sprites added through drag & drop)
					var early_ = get_face(element_.params.id_); if ( sprite_exists(early_) ) { sfx_play(snd_updated); if ( element_.getData("clear_") ) { FACE_CURRENT = early_; FACE_ORIGINAL = FACE_CURRENT; } soup_checkout(element_.getData("inputsoup_"), false, element_.getData("inputglobal_")).set(element_.params.id_); soup_checkout(element_.getData("imagesoup_"), false, element_.getData("imageglobal_")).set(early_); soup_checkout("datafunc", false)(); exit; }
					
					var spr_ = [], cur_ = element_.getData("chara"), spr_exp = struct_get_names(global.faces_dict[$ cur_]), spr_len = array_length(spr_exp), spr_i = 0; //Folders filled with sprites will have their sprites shown here
					repeat ( spr_len ) {
						var exp_ = spr_exp[spr_i], finalname = $"spr_{cur_}_{exp_}", myspr = get_face(finalname);
						if ( exp_ != "NEW SPRITE" ) {
							array_push(spr_, new LuiImageButton({ value: myspr, draw_normal: true, }).setSize(sprite_get_width(myspr), sprite_get_height(myspr)).setData("face", myspr).setData("facename", finalname).setFlexAlignSelf(flexpanel_align.center).setTooltip($"{finalname}\n[face,{finalname}]", true)
							.setData("inputsoup_", element_.getData("inputsoup_")).setData("inputglobal_", element_.getData("inputglobal_")).setData("imagesoup_", element_.getData("imagesoup_")).setData("imageglobal_", element_.getData("imageglobal_")).setData("clear_", element_.getData("clear_"))
							.addEvent(LUI_EV_CLICK, function(element_) { sfx_play(snd_updated); if ( element_.getData("clear_") ) { FACE_CURRENT = element_.getData("face"); FACE_ORIGINAL = FACE_CURRENT; } soup_checkout(element_.getData("inputsoup_"), false, element_.getData("inputglobal_")).set(element_.getData("facename")); soup_checkout(element_.getData("imagesoup_"), false, element_.getData("imageglobal_")).set(element_.getData("face")); soup_checkout("datafunc", false)(); })
							.addEvent(LUI_EV_MOUSE_ENTER, function(element_) { if ( sprite_get_number(element_.get()) > 1 ) { element_.imgspd = 0.15; } }).addEvent(LUI_EV_MOUSE_LEAVE, function(element_) { element_.imgspd = 0; element_.subimg = 0; })
							);
						}
					spr_i++; }
					
					#region Sort Names Alphabetically
						array_sort(spr_, function(arrcur_, arrnext_) {
							if ( string_lower(arrcur_.value) < string_lower(arrnext_.value) ) { return -1; }
							else if ( string_lower(arrcur_.value) > string_lower(arrnext_.value) ) { return 1; }
							else { return 0; }
						});
					#endregion
					get_.addContent(new LuiScrollPanel({ height: 400, scroll_pin_edge_offset:10, sprite_panel: false, sound_right: snd_throw, }).addContent(spr_).addEvent(LUI_EV_CREATE, function(element_) { soup_store("scrollsub", element_); })); //Add new panel and stash it so we can destroy it later
				})
			);
		options_i++; }
		
		#region Sort Names Alphabetically
			array_sort(options_, function(arrcur_, arrnext_) {
				if ( string_lower(arrcur_.value) < string_lower(arrnext_.value) ) { return -1; }
				else if ( string_lower(arrcur_.value) > string_lower(arrnext_.value) ) { return 1; }
				else { return 0; }
			});
		#endregion
		
		#region Add Default Options
			array_push(options_, new LuiText({ value: "Test Face", font: fnt_speech, text_halign: fa_center, text_valign: fa_middle, }).setPadding(5)
				.setData("inputsoup_", inputsoup_).setData("inputglobal_", inputglobal_).setData("imagesoup_", imagesoup_).setData("imageglobal_", imageglobal_).setData("clear_", clear_)
				.addEvent(LUI_EV_MOUSE_ENTER, function(element_) { element_.color = c_yellow; sfx_play(snd_sel_switch); element_.main_ui.animate(element_, "xoff", 10, 0.30, global.Ease.OutBack, 0); })
				.addEvent(LUI_EV_MOUSE_LEAVE, function(element_) { element_.color = c_white; element_.main_ui.animate(element_, "xoff", 0, 0.15); })
				.addEvent(LUI_EV_CLICK, function(element_) { sfx_play(snd_updated); if ( element_.getData("clear_") ) { FACE_CURRENT = spr_face_test; FACE_ORIGINAL = FACE_CURRENT; } soup_checkout(element_.getData("inputsoup_"), false, element_.getData("inputglobal_")).set("spr_face_test"); soup_checkout(element_.getData("imagesoup_"), false, element_.getData("imageglobal_")).set(element_.getData("face")); soup_checkout("datafunc", false)();})
			);
			array_push(options_, new LuiText({ value: "Blank Page Face", font: fnt_speech, text_halign: fa_center, text_valign: fa_middle, }).setPadding(5)
				.setData("inputsoup_", inputsoup_).setData("inputglobal_", inputglobal_).setData("imagesoup_", imagesoup_).setData("imageglobal_", imageglobal_).setData("clear_", clear_)
				.addEvent(LUI_EV_MOUSE_ENTER, function(element_) { element_.color = c_yellow; sfx_play(snd_sel_switch); element_.main_ui.animate(element_, "xoff", 10, 0.30, global.Ease.OutBack, 0); })
				.addEvent(LUI_EV_MOUSE_LEAVE, function(element_) { element_.color = c_white; element_.main_ui.animate(element_, "xoff", 0, 0.15); })
				.addEvent(LUI_EV_CLICK, function(element_) { sfx_play(snd_updated); if ( element_.getData("clear_") ) { FACE_CURRENT = spr_face_blank; FACE_ORIGINAL = FACE_CURRENT; } soup_checkout(element_.getData("inputsoup_"), false, element_.getData("inputglobal_")).set("spr_face_blank"); soup_checkout(element_.getData("imagesoup_"), false, element_.getData("imageglobal_")).set(element_.getData("face")); soup_checkout("datafunc", false)(); })
			);
			array_push(options_, new LuiText({ value: "Add From File... [[->]", font: fnt_speech, text_halign: fa_center, text_valign: fa_middle, color: c_yellow, }).setPadding(5)
				.setData("inputsoup_", inputsoup_).setData("inputglobal_", inputglobal_).setData("imagesoup_", imagesoup_).setData("imageglobal_", imageglobal_).setData("clear_", clear_)
				.addEvent(LUI_EV_MOUSE_ENTER, function(element_) { element_.color = c_orange; sfx_play(snd_sel_switch); element_.main_ui.animate(element_, "xoff", 10, 0.30, global.Ease.OutBack, 0); })
				.addEvent(LUI_EV_MOUSE_LEAVE, function(element_) { element_.color = c_yellow; element_.main_ui.animate(element_, "xoff", 0, 0.15); })
				.addEvent(LUI_EV_CLICK, function(element_) { 
					sfx_play(snd_equip); 
					var result = get_open_filename_ext("Image File (.PNG Only)|*.png", "", directory_get_pictures_path(), "Select a sprite to import."), myname_;
					if ( result == -1 || result == "" ) { result = -1; myname_ = ""; } else { myname_ = string_exclude(string_replace(string_replace(filename_name(result), "_strip", ""), ".png", ""), "0123456789"); result = external_ensure(myname_, filename_name(result), result, , SYSTEMUI.ui_tab == 0 ? true : false); }
					if ( element_.getData("clear_") ) { FACE_CURRENT = result; FACE_ORIGINAL = FACE_CURRENT; } 
					soup_checkout(element_.getData("inputsoup_"), false, element_.getData("inputglobal_")).set(myname_); 
					soup_checkout(element_.getData("imagesoup_"), false, element_.getData("imageglobal_")).set(result);
					soup_checkout("datafunc", false)();
				})
			);
			array_push(options_, new LuiText({ value: "Clear Page Face", font: fnt_speech, text_halign: fa_center, text_valign: fa_middle, color: c_red, }).setPadding(5)
				.setData("inputsoup_", inputsoup_).setData("inputglobal_", inputglobal_).setData("imagesoup_", imagesoup_).setData("imageglobal_", imageglobal_).setData("clear_", clear_)
				.addEvent(LUI_EV_MOUSE_ENTER, function(element_) { element_.color = c_orange; sfx_play(snd_sel_switch); element_.main_ui.animate(element_, "xoff", 10, 0.30, global.Ease.OutBack, 0); })
				.addEvent(LUI_EV_MOUSE_LEAVE, function(element_) { element_.color = c_red; element_.main_ui.animate(element_, "xoff", 0, 0.15); })
				.addEvent(LUI_EV_CLICK, function(element_) { sfx_play(snd_hurtpowerful); if ( element_.getData("clear_") ) { FACE_CURRENT = -1; FACE_ORIGINAL = FACE_CURRENT; } soup_checkout(element_.getData("inputsoup_"), false, element_.getData("inputglobal_")).set(-1); soup_checkout(element_.getData("imagesoup_"), false, element_.getData("imageglobal_")).set(""); soup_checkout("datafunc", false)(); })
			);
		#endregion

		var dataarr = [
			new LuiRow().setFlexGrow(1).centerContent().addContent([
				new LuiScrollPanel({ height: 400, scroll_pin_edge_offset:10, sprite_panel: false, sound_right: snd_throw, }).addContent(options_),
				new LuiText({ value: $"Select a character!\n\nFaces will show up once\nselected. Then scroll to\nfind the perfect sprite\nfor your dialogue!\n\nThis only adds a face for\nthe current dialogue page.", auto_width: false, auto_height: false, font: fnt_speech, text_halign: fa_center, text_valign: fa_center, }).addEvent(LUI_EV_CREATE, function(element_) { soup_store("scrollsub", element_); }),
			]).addEvent(LUI_EV_CREATE, function(element_) { soup_store("scrollmain", element_); }), //Stash panel so we can add another panel to this row
		];

		soup_store("datafunc", method({ clear_, }, function() { soup_checkout("choosemain", false).destroy(); FACE_INDEX = clamp(FACE_INDEX, 0, sprite_get_number(FACE_CURRENT) - 1); if ( clear_ ) { soup_store_clear(); SYSTEMUI.ui_paused = false; } }));
		var maincan = soupy_popup(dataarr, method({ clear_ }, function() { if ( clear_ ) { soup_store_clear(); FACE_INDEX = clamp(FACE_INDEX, 0, sprite_get_number(FACE_CURRENT) - 1); SYSTEMUI.ui_paused = false; } }), "Nevermind", , , , , , multiple_, 2); soup_store("choosemain", maincan); 
	}
	
	///@desc Function for choosing an externally added border
	function external_choose_border() {
		#region Add All Borders
			var options_ = [], bords_ = tag_get_assets("borders"), bords_len = array_length(bords_), bords_i = 0;
			repeat ( bords_len ) {
				var cur_ = bords_[bords_i], myspr = get_border(asset_get_index(cur_)), myname = get_border(asset_get_index(cur_), "name");
				array_push(options_, 
					new LuiImageButton({ value: myspr, maintain_aspect: false, id_: string_letters(myname) != "" ? myname : sprite_get_name(myname), isnew: false }).setSize(70, 70).setFlexAlignSelf(flexpanel_align.center)
					.addEvent(LUI_EV_MOUSE_ENTER, function(e_) { if ( sprite_get_number(e_.get()) > 1 ) { e_.imgspd = 0.15; } }).addEvent(LUI_EV_MOUSE_LEAVE, function(e_) { e_.imgspd = 0; e_.subimg = 0; })
					.addEvent(LUI_EV_CREATE, function(e_) { 
						var myname = e_.params.id_, result = get_border(myname, "NEW SPRITE"), text_ = $"[border,{myname}]";
						if ( asset_get_index(result) == -1 ) { e_.params.isnew = ( result != undefined && result ) ? true : false; if ( e_.params.isnew ) { text_ = $"[border,{myname}] (NEW!)"; } }
						e_.setTooltip(text_);
					})
					.addEvent(LUI_EV_CLICK, function(e_) { 
						var myname = e_.params.id_, bord_ = global.bords_dict[$ myname];
						if ( !is_undefined(bord_) ) { bord_[$ "NEW SPRITE"] = false; }
						sfx_play(snd_updated); soup_checkout("datainputB", false, true).set(myname); soup_checkout("dataimageB", false, true).set(e_.get()); soup_checkout("datafunc", false)();
					})
				);
			bords_i++; }
		#endregion
		
		#region Add Default Options
			array_push(options_, new LuiText({ value: "Add From File... [[->]", font: fnt_speech, text_halign: fa_center, text_valign: fa_middle, color: c_yellow, }).setPadding(5)
				.addEvent(LUI_EV_MOUSE_ENTER, function(element_) { element_.color = c_orange; sfx_play(snd_sel_switch); element_.main_ui.animate(element_, "xoff", 10, 0.30, global.Ease.OutBack, 0); })
				.addEvent(LUI_EV_MOUSE_LEAVE, function(element_) { element_.color = c_yellow; element_.main_ui.animate(element_, "xoff", 0, 0.15); })
				.addEvent(LUI_EV_CLICK, function(element_) { 
					sfx_play(snd_equip); 
					var result = get_open_filename_ext("Image File (.PNG Only)|*.png", "", directory_get_pictures_path(), "Select a sprite to import."), myname_;
					if ( result == -1 || result == "" ) { result = spr_border_undertale; myname_ = "spr_border_undertale"; } else { myname_ = string_exclude(string_replace(string_replace(filename_name(result), "_strip", ""), ".png", ""), "0123456789"); result = external_ensure(myname_, filename_name(result), result, 1, false); }
					SYSTEMUI.spr_bord = result; SYSTEMUI.bord_name = myname_; SYSTEMUI.bord_prev = SYSTEMUI.spr_bord;
					sfx_play(snd_updated); soup_checkout("datainputB", false, true).set(myname_); soup_checkout("dataimageB", false, true).set(result); soup_checkout("datafunc", false)();
				})
			);
		#endregion
		
		var dataarr = [
			new LuiRow().setFlexGrow(1).centerContent().addContent([
				new LuiScrollPanel({ height: 400, scroll_pin_edge_offset:10, sprite_panel: false, sound_right: snd_throw, }).addContent(options_),
				new LuiText({ value: $"Select a dialogue border!\nThis is the box displayed\naround your text.\nSome are animated!\nScroll to find your perfect\nsprite for your dialogue!", auto_width: false, auto_height: false, font: fnt_speech, text_halign: fa_center, text_valign: fa_center, }).addEvent(LUI_EV_CREATE, function(element_) { soup_store("scrollsub", element_); }),
			]).addEvent(LUI_EV_CREATE, function(element_) { soup_store("scrollmain", element_); }), //Stash panel so we can add another panel to this row
		];
		
		soup_store("datafunc", function() { soup_checkout("choosemain", false).destroy(); soup_store_clear(); SYSTEMUI.ui_paused = false; });
		var maincan = soupy_popup(dataarr, function() { soup_store_clear(); SYSTEMUI.ui_paused = false; }, "Nevermind", , , , , , , 2); soup_store("choosemain", maincan); 
	}
	
	///@desc Function for choosing an externally added font
	function external_choose_font() {
		#region Add bundled fonts
			var custom_ = is_undefined(soup_checkout("customfonts", false, true));
			var options_ = [], fonts_len = array_length((!custom_ ? global.fonts_dict_list_custom : global.fonts_dict_list)), fonts_i = 0;
			repeat ( fonts_len ) {
				var get_ = (!custom_ ? global.fonts_dict_list_custom : global.fonts_dict_list);
				var cur_ = get_[fonts_i];
				options_[fonts_i] = new LuiText({ value: $"{cur_} (AaBbCc)", id_: cur_, font: cur_, text_halign: fa_center, text_valign: fa_middle, color: c_white, isnew: false, scribbletext: true, }).setData("customs", custom_)
					.addEvent(LUI_EV_MOUSE_ENTER, function(element_) { element_.color = c_yellow; element_.value = $"[wheel]{element_.value}"; sfx_play(snd_sel_switch); element_.main_ui.animate(element_, "xoff", 10, 0.30, global.Ease.OutBack, 0); })
					.addEvent(LUI_EV_MOUSE_LEAVE, function(element_) { element_.color = element_.color_o; element_.value = string_replace(element_.value, "[wheel]", ""); element_.main_ui.animate(element_, "xoff", 0, 0.15); })
					.addEvent(LUI_EV_CLICK, function(e_) { 
						var myname = e_.params.id_, fonts_ = global.fonts_dict[$ myname];
						var custom_ = e_.getData("customs");
						if ( !is_undefined(fonts_) ) { fonts_[$ "NEW SPRITE"] = false; } sfx_play(snd_select);
						if ( custom_ ) { soup_checkout(SYSTEMUI.ui_tab != 4 ? "datainputS" : "datainputbox", false, true).set(myname); soup_checkout(SYSTEMUI.ui_tab != 4 ? "datafont" : "datafontbox", false, true).font = myname; }
						else { soup_checkout(soup_checkout("getfont", false, true), false, true).font = myname; }
						soup_checkout("datafunc", false)();
					})
					.addEvent(LUI_EV_CREATE, function(e_) { 
						var result = global.fonts_dict[$ e_.params.id_]; 
						e_.isnew = ( result != undefined && result[$ "NEW SPRITE"] != undefined && result[$ "NEW SPRITE"] ); if ( e_.isnew ) { e_.value = $"{e_.value} (NEW!)"; }
						if ( result != undefined && result[$ "NEW EXTERNALLY"] != undefined ) { e_.color = c_cyan; e_[$ "color_o"] = c_cyan; e_.setTooltip("[rainbow]Unique and recent!", true, , true); } else { e_[$ "color_o"] = c_white; }
					})
			fonts_i++; }
		#endregion
		
		#region Sort Names Alphabetically
			array_sort(options_, function(arrcur_, arrnext_) {
				if ( string_lower(arrcur_.value) < string_lower(arrnext_.value) ) { return -1; }
				else if ( string_lower(arrcur_.value) > string_lower(arrnext_.value) ) { return 1; }
				else { return 0; }
			});
		#endregion
		
		#region Add Default Options
			array_push(options_, new LuiText({ value: "Add From File... [[->]", font: fnt_speech, text_halign: fa_center, text_valign: fa_middle, color: c_yellow, }).setPadding(5).setData("customs", custom_)
				.addEvent(LUI_EV_MOUSE_ENTER, function(element_) { element_.color = c_orange; sfx_play(snd_sel_switch); element_.main_ui.animate(element_, "xoff", 10, 0.30, global.Ease.OutBack, 0); })
				.addEvent(LUI_EV_MOUSE_LEAVE, function(element_) { element_.color = c_yellow; element_.main_ui.animate(element_, "xoff", 0, 0.15); })
				.addEvent(LUI_EV_CLICK, function(element_) { 
					sfx_play(snd_equip); 
					var result = get_open_filename_ext("GameMaker Strip (_strip#.PNG Only)|*.png", "", directory_get_pictures_path(), "Select a spritefont to import."), myname_;
					if ( result == -1 || result == "" ) { result = "fnt_determination"; myname_ = result; } else { myname_ = string_exclude(string_replace(string_replace(string_replace(filename_name(result), "spr_", ""), "_strip", ""), ".png", ""), "0123456789"); result = external_ensure(myname_, filename_name(result), result, 2, false); }
					if ( result == -1 || result == "" ) { result = "fnt_determination"; myname_ = result; }
					var custom_ = element_.getData("customs");
					if ( custom_ ) { soup_checkout(SYSTEMUI.ui_tab != 4 ? "datainputS" : "datainputbox", false, true).set(myname_); soup_checkout(SYSTEMUI.ui_tab != 4 ? "datafont" : "datafontbox", false, true).font = myname_; sfx_play(snd_updated); }
					else { soup_checkout(soup_checkout("getfont", false, true), false, true).font = myname_; }
					soup_checkout("datafunc", false)();
				})
			);
		#endregion
		
		var dataarr = [
			new LuiColumn().setFlexGrow(1).centerContent().addContent([
				new LuiScrollPanel({ height: 360, sprite_panel: false, sound_right: snd_throw, }).addContent(options_),
				new LuiText({ value: $"Select a dialogue font! This is the style your dialogue text\nwill be rendered with. Find your perfect font to use!", auto_width: false, auto_height: false, y: -10, font: fnt_speech, text_halign: fa_center, text_valign: fa_center, }).addEvent(LUI_EV_CREATE, function(element_) { soup_store("scrollsub", element_); }),
			]).addEvent(LUI_EV_CREATE, function(element_) { soup_store("scrollmain", element_); }), //Stash panel so we can add another panel to this row
		];
		
		soup_store("datafunc", function() { soup_checkout("choosemain", false).destroy(); soup_store_clear(); if ( is_undefined(soup_checkout("customfonts", false, true)) ) { SYSTEMUI.ui_paused = false; } });
		var maincan = soupy_popup(dataarr, function() { soup_store_clear(); if ( is_undefined(soup_checkout("customfonts", false, true)) ) { SYSTEMUI.ui_paused = false; } }, "Nevermind", , , , , , !custom_, 2); soup_store("choosemain", maincan); 
	}
	
	///@desc Function for editing the spacing between fonts
	function external_edit_fonts() {
		var dataarr = [
			new LuiText({ value: $"Tweak the spacing between letters for your custom font.", y: -10, font: fnt_speech, text_halign: fa_center, text_valign: fa_center, }),
			new LuiRow().setFlexGrow(1).centerContent().addContent([ //Choosing a sprite
				new LuiText({ value: "Font:", width: 65, text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }).setTooltip("Custom fonts only.", true, , true),
				new LuiButton({ text: "Choose...", height: 40, width: 100, }).addEvent(LUI_EV_CLICK, external_choose_font),
				new LuiText({ value: "AaBbCc", width: 100, text_halign: fa_center, text_valign: fa_middle, font: "fnt_speech", scribbletext: true, }).addEvent(LUI_EV_CREATE, function(e_) { soup_store("datafontcustom", e_, , true); })
				.addEvent(LUI_EV_MOUSE_LEFT_PRESSED, function(element_) { element_.main_ui.animate(element_, "yoff", 0, 1, global.Ease.OutElastic, 10); sfx_play(snd_squish); })
			]),
			new LuiRow().setFlexGrow(1).centerContent().addContent([
				new LuiText({ value: "Separation:", width: 140, text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }),
				new LuiInput({ value: "14", height: 40, placeholder: "123456", offset: 12, type_sfx: snd_txttype, color_normal: c_white, color_hover: c_gray, input_mode: LUI_INPUT_MODE.numbers, max_length: 2, })
				.addEvent(LUI_EV_CREATE, function(e_) { soup_store("sep", e_, , true); }),
			]),
			new LuiButton({ text: "Make changes!", height: 40, }).addEvent(LUI_EV_CLICK, function () { 
				var font_ = soup_checkout("datafontcustom", false, true).font, result = soup_checkout("sep", , true).get(), value = result == "" ? 14 : real(result);
				if ( font_ != "fnt_speech" ) {
					scribble_glyph_set(font_, all, SCRIBBLE_GLYPH.SEPARATION, value);
					scribble_glyph_set($"{font_}_outline", all, SCRIBBLE_GLYPH.SEPARATION, value);
					scribble_refresh_everything();
					soup_checkout("datafunccustomfonts", , true)(); sfx_play(snd_sparkle);
				}
				else { soupy_message("You haven't selected any|custom font for editing.", , 300, , , snd_error, , , true); }
			}),
		];
		soup_store("customfonts", , , true); soup_store("getfont", "datafontcustom", , true);
		soup_store("datafunccustomfonts", function() { soup_checkout("choosemaincustomfonts", false, true).destroy(); soup_store_clear(); soup_checkout("customfonts", , true); soup_checkout("getfont", , true); SYSTEMUI.ui_paused = false; }, , true);
		var maincan = soupy_popup(dataarr, function() { soup_store_clear(); soup_checkout("customfonts", , true); soup_checkout("getfont", , true); SYSTEMUI.ui_paused = false; }, "Nevermind", , , , , , , 2); soup_store("choosemaincustomfonts", maincan, , true); 
	}
		
	function external_choose_mini(face_ = -1, index_ = 0, text_ = "Text", font_ = "fnt_determination", smooth_ = false, x_ = -1, y_ = -1, id_ = -1, name_ = "") {
		soup_store("minisprite", face_ != -1 ? name_ : face_); soup_store("miniindex", index_); soup_store("minitext", text_); soup_store("minianim", smooth_); soup_store("minifont", font_);
		var miniarr = [
			new LuiText({ value: ( id_ == -1 ? "Create a mini speech bubble!" : "Edit current mini speech bubble." ), text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }),
			new LuiRow().setFlexGrow(1).centerContent().addContent([
				new LuiText({ value: "Sprite:", width: 100, text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }),
				new LuiButton({ text: "Choose...", height: 40, width: 100, }).addEvent(LUI_EV_CLICK, function(element_) { external_choose_face(true, , false, , false, false); }),
				new LuiInput({ value: soup_checkout("minisprite", false), height: 40, placeholder: "spr_face_test", offset: 12, type_sfx: snd_txttype, color_normal: c_white, color_hover: c_gray, }).bindVariable(global.soupstore, "minisprite").addEvent(LUI_EV_CREATE, function(e_) { soup_store("datainput", e_); }).addEvent(LUI_EV_VALUE_UPDATE, function(e_) { 
					var spr_ = soup_checkout("dataimage", false), getface = get_face(e_.get());
					spr_.set(getface == -1 ? spr_gui_icons : getface); spr_.subimg = ( getface == -1 ? 3 : 0 );
				}),
				new LuiImage({ value: spr_gui_icons, subimg: 3, draw_normal: true, }).setSize(70, 70).addEvent(LUI_EV_CREATE, function(e_) { var mini_ = soup_checkout("minisprite", false); soup_store("dataimage", e_); e_.set(mini_ == -1 ? spr_gui_icons : get_face(mini_)); }),
			]),
			new LuiRow().setFlexGrow(1).centerContent().addContent([
				new LuiText({ value: "Image Index:", width: 150, text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }),
				new LuiInput({ value: soup_checkout("miniindex", false), width: 50, placeholder: "123456", offset: 12, type_sfx: snd_txttype, color_normal: c_white, color_hover: c_gray, input_mode: LUI_INPUT_MODE.numbers, }).setPadding(20).bindVariable(global.soupstore, "miniindex").addEvent(LUI_EV_VALUE_UPDATE, function(e_) { 
					var spr_ = soup_checkout("dataimage", false), value = e_.get(); if ( spr_.value != spr_gui_icons ) { spr_.subimg = real(value == "" ? 0 : value); }
				}),
			]),
			new LuiRow().setFlexGrow(1).centerContent().addContent([
				new LuiText({ value: "Text:", width: 50, text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }),
				new LuiInput({ value: soup_checkout("minitext", false), placeholder: "Test text 1, 2, 3.", offset: 12, type_sfx: snd_txttype, color_normal: c_white, color_hover: c_gray, }).setPadding(20).bindVariable(global.soupstore, "minitext"),
			]),
			new LuiRow().setFlexGrow(1).centerContent().addContent([
				new LuiText({ value: "Font:", text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }),
				new LuiInput({ value: soup_checkout("minifont", false), placeholder: "fnt_determination", offset: 12, type_sfx: snd_txttype, color_normal: c_white, color_hover: c_gray, }).setPadding(20).bindVariable(global.soupstore, "minifont").addEvent(LUI_EV_VALUE_UPDATE, function(e_) {
					var prev_ = soup_checkout("minipreview", false), value = e_.get(); prev_.font = scribble_font_exists(value) ? value : "fnt_determination";
				}),
				new LuiText({ value: "AaBbCc", text_halign: fa_center, text_valign: fa_middle, font: soup_checkout("minifont", false), scribbletext: true, }).addEvent(LUI_EV_CREATE, function(e_) { soup_store("minipreview", e_); }),
			]),
			new LuiRow().setFlexGrow(1).centerContent().addContent([
				new LuiText({ value: "Smooth Animation:", text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }),
				new LuiToggleSwitch({ value: soup_checkout("minianim", false), checkbox_spr: spr_gui_icons, checkbox_spr_index: 6, checkbox_clr: c_white, sound_click: snd_bump, sound_click_pitch: 1.3, ease: global.Ease.OutBack, }).bindVariable(global.soupstore, "minianim").setWidth(50),
			]),
			new LuiText({ value: "Left Click - Move mini | Right Click (Held) - Delete mini | Double Left Click - Edit mini", color: c_gray, text_halign: fa_center, text_valign: fa_middle, font: fnt_determination_nomono, }),
			new LuiText({ value: "Note: Mini speeches only show up on the current highlighted page\nand within the dialogue box.", auto_width: false, auto_height: false, color: c_gray, text_halign: fa_center, text_valign: fa_middle, }),
			new LuiText({ value: "You can drag a face sprite on here too, btw! New sprites are\nimmediately added.", auto_width: false, auto_height: false, color: c_gray, text_halign: fa_center, text_valign: fa_middle, }),
			new LuiButton({ text: "Let's get soupy!!", height: 35, }).setData("xx", x_).setData("yy", y_).setData("id_", id_).addEvent(LUI_EV_CLICK, function(element_) {
				var txt_ = soup_checkout("minitext", false), spr_ = get_face(soup_checkout("minisprite", false)), index_ = soup_checkout("miniindex", false), font_ = soup_checkout("minifont", false);
				if ( string_lettersdigits(txt_) == "" ) { SYSTEMUI.ui_paused = false; soupy_message("You haven't even written any|dialogue yet!!", "Go Back", 300, , , snd_error, , , true); exit; }
				if ( spr_ == -1 ) { SYSTEMUI.ui_paused = false; soupy_message("Make sure your face sprite|is a valid sprite.", "Go Back", 300, , , snd_error, , , true); exit; }
				if ( string_lettersdigits(font_) == "" ) { font_ = "fnt_determination"; }
									
				var struct_ = { name: soup_checkout("datainput", false).get(), text: txt_, face: spr_, index: index_ == "" ? 0 : real(index_), alpha: 1, font: font_, smooth: soup_checkout("minianim", false), page: SYSTEMUI.dial_text_page, };
				var x_ = element_.getData("xx"), y_ = element_.getData("yy"), id_ = element_.getData("id_");
				if ( id_ != -1 ) { instance_destroy(id_); sfx_play(snd_updated); }
				instance_create_depth(x_ == -1 ? random_range(30, 310) : x_, y_ == -1 ? random_range(310, 470) : y_, -1, obj_mini, struct_);
				var maincan = soup_checkout("datamain", false);
				soup_store_clear(); SYSTEMUI.ui_paused = false; maincan.destroy();
			}),
		];
		var maincan = soupy_popup(miniarr, function() { soup_store_clear(); SYSTEMUI.ui_paused = false; }, "Nevermind", , , , , , , 2);
		soup_store("datamain", maincan);
	}
	
	///@desc Function for editing the Scribble typewriter animation
	function external_edit_typew() {
		var easeExample = function (stop_ = false) {
			var gettween = soup_checkout("dataease_tween"); if ( gettween != undefined ) { TweenStop(gettween); TweenDestroy(gettween); TweenDestroy(SYSTEMUI); show_debug_message("Tween destroyed"); }
			if ( stop_ ) { SYSTEMUI.soupy_lui.animate(soup_checkout("dataease_soul", false), "yoff", 0, 0, , -80); exit; }
			var func_ = function() { SYSTEMUI.soupy_lui.animate(soup_checkout("dataease_soul", false), "yoff", 0, 1, soup_checkout("dataease_tweenease", false), -80); }
			var tween = TweenFire("?", SYSTEMUI, "$90", "#3", "@continue", func_);
			soup_store("dataease_tween", tween); func_();
		}
		var dataarr = [
			new LuiText({ value: "Edit how the typewriter makes text appear!", text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }),
			new LuiText({ value: "Instead of characters appearing instantly, you can give characters\nan easing animation to truly customize dialogue to your liking!", text_halign: fa_center, text_valign: fa_middle, color: c_gray, font: fnt_determination, }),
			
			new LuiRow().setFlexGrow(1).centerContent().addContent([
				new LuiText({ value: "Easing Type:", text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }).setTooltip("Sets the easing out algorithm\nthe typewriter will use.\nFor more info, visit:\n[c_yellow]https://easings.net/ (right click me)", true, , true).addEvent(LUI_EV_CLICK_R, function() { execute_shell_simple("https://easings.net/", , , 0); }),
				new LuiComboBox({ height: 35, placeholder: "Select easing type...", noborder: true, height_items: 260, }).addItems([
					new LuiComboBoxItem({ text: "NONE" }).setData("easeExample", easeExample).addEvent(LUI_EV_CLICK, function(e_) { 
						soup_store("dataeasetype", SCRIBBLE_EASE.NONE); 
						var func_ = e_.getData("easeExample"); func_(true); 
					}).addEvent(LUI_EV_MOUSE_ENTER, function(element_) { element_.color = c_yellow; element_.main_ui.animate(element_, "xoff", 5, 0.30, global.Ease.OutBack, 0); }).addEvent(LUI_EV_MOUSE_LEAVE, function(element_) { element_.color = c_white; element_.main_ui.animate(element_, "xoff", 0, 0.15); }),
					new LuiComboBoxItem({ text: "LINEAR" }).setData("easeExample", easeExample).addEvent(LUI_EV_CLICK, function(e_) { 
						soup_store("dataeasetype", SCRIBBLE_EASE.LINEAR); 
						var func_ = e_.getData("easeExample"); func_(true); 
					}).addEvent(LUI_EV_MOUSE_ENTER, function(element_) { element_.color = c_yellow; element_.main_ui.animate(element_, "xoff", 5, 0.30, global.Ease.OutBack, 0); }).addEvent(LUI_EV_MOUSE_LEAVE, function(element_) { element_.color = c_white; element_.main_ui.animate(element_, "xoff", 0, 0.15); }),
					new LuiComboBoxItem({ text: "QUAD" }).setData("easeExample", easeExample).addEvent(LUI_EV_CLICK, function(e_) { 
						soup_store("dataeasetype", SCRIBBLE_EASE.QUAD); 
						var func_ = e_.getData("easeExample"); soup_store("dataease_tweenease", global.Ease.OutQuad); func_(); 
					}).addEvent(LUI_EV_MOUSE_ENTER, function(element_) { element_.color = c_yellow; element_.main_ui.animate(element_, "xoff", 5, 0.30, global.Ease.OutBack, 0); }).addEvent(LUI_EV_MOUSE_LEAVE, function(element_) { element_.color = c_white; element_.main_ui.animate(element_, "xoff", 0, 0.15); }),
					new LuiComboBoxItem({ text: "CUBIC" }).setData("easeExample", easeExample).addEvent(LUI_EV_CLICK, function(e_) { 
						soup_store("dataeasetype", SCRIBBLE_EASE.CUBIC); 
						var func_ = e_.getData("easeExample"); soup_store("dataease_tweenease", global.Ease.OutCubic); func_(); 
					}).addEvent(LUI_EV_MOUSE_ENTER, function(element_) { element_.color = c_yellow; element_.main_ui.animate(element_, "xoff", 5, 0.30, global.Ease.OutBack, 0); }).addEvent(LUI_EV_MOUSE_LEAVE, function(element_) { element_.color = c_white; element_.main_ui.animate(element_, "xoff", 0, 0.15); }),
					new LuiComboBoxItem({ text: "QUART" }).setData("easeExample", easeExample).addEvent(LUI_EV_CLICK, function(e_) { 
						soup_store("dataeasetype", SCRIBBLE_EASE.QUART); 
						var func_ = e_.getData("easeExample"); soup_store("dataease_tweenease", global.Ease.OutQuart); func_(); 
					}).addEvent(LUI_EV_MOUSE_ENTER, function(element_) { element_.color = c_yellow; element_.main_ui.animate(element_, "xoff", 5, 0.30, global.Ease.OutBack, 0); }).addEvent(LUI_EV_MOUSE_LEAVE, function(element_) { element_.color = c_white; element_.main_ui.animate(element_, "xoff", 0, 0.15); }),
					new LuiComboBoxItem({ text: "QUINT" }).setData("easeExample", easeExample).addEvent(LUI_EV_CLICK, function(e_) { 
						soup_store("dataeasetype", SCRIBBLE_EASE.QUINT); 
						var func_ = e_.getData("easeExample"); soup_store("dataease_tweenease", global.Ease.OutQuint); func_(); 
					}).addEvent(LUI_EV_MOUSE_ENTER, function(element_) { element_.color = c_yellow; element_.main_ui.animate(element_, "xoff", 5, 0.30, global.Ease.OutBack, 0); }).addEvent(LUI_EV_MOUSE_LEAVE, function(element_) { element_.color = c_white; element_.main_ui.animate(element_, "xoff", 0, 0.15); }),
					new LuiComboBoxItem({ text: "SINE" }).setData("easeExample", easeExample).addEvent(LUI_EV_CLICK, function(e_) { 
						soup_store("dataeasetype", SCRIBBLE_EASE.SINE); 
						var func_ = e_.getData("easeExample"); soup_store("dataease_tweenease", global.Ease.OutSine); func_(); 
					}).addEvent(LUI_EV_MOUSE_ENTER, function(element_) { element_.color = c_yellow; element_.main_ui.animate(element_, "xoff", 5, 0.30, global.Ease.OutBack, 0); }).addEvent(LUI_EV_MOUSE_LEAVE, function(element_) { element_.color = c_white; element_.main_ui.animate(element_, "xoff", 0, 0.15); }),
					new LuiComboBoxItem({ text: "EXPO" }).setData("easeExample", easeExample).addEvent(LUI_EV_CLICK, function(e_) { 
						soup_store("dataeasetype", SCRIBBLE_EASE.EXPO); 
						var func_ = e_.getData("easeExample"); soup_store("dataease_tweenease", global.Ease.OutExpo); func_(); 
					}).addEvent(LUI_EV_MOUSE_ENTER, function(element_) { element_.color = c_yellow; element_.main_ui.animate(element_, "xoff", 5, 0.30, global.Ease.OutBack, 0); }).addEvent(LUI_EV_MOUSE_LEAVE, function(element_) { element_.color = c_white; element_.main_ui.animate(element_, "xoff", 0, 0.15); }),
					new LuiComboBoxItem({ text: "CIRC" }).setData("easeExample", easeExample).addEvent(LUI_EV_CLICK, function(e_) { 
						soup_store("dataeasetype", SCRIBBLE_EASE.CIRC); 
						var func_ = e_.getData("easeExample"); soup_store("dataease_tweenease", global.Ease.OutCirc); func_(); 
					}).addEvent(LUI_EV_MOUSE_ENTER, function(element_) { element_.color = c_yellow; element_.main_ui.animate(element_, "xoff", 5, 0.30, global.Ease.OutBack, 0); }).addEvent(LUI_EV_MOUSE_LEAVE, function(element_) { element_.color = c_white; element_.main_ui.animate(element_, "xoff", 0, 0.15); }),
					new LuiComboBoxItem({ text: "BACK" }).setData("easeExample", easeExample).addEvent(LUI_EV_CLICK, function(e_) { 
						soup_store("dataeasetype", SCRIBBLE_EASE.BACK); 
						var func_ = e_.getData("easeExample"); soup_store("dataease_tweenease", global.Ease.OutBack); func_(); 
					}).addEvent(LUI_EV_MOUSE_ENTER, function(element_) { element_.color = c_yellow; element_.main_ui.animate(element_, "xoff", 5, 0.30, global.Ease.OutBack, 0); }).addEvent(LUI_EV_MOUSE_LEAVE, function(element_) { element_.color = c_white; element_.main_ui.animate(element_, "xoff", 0, 0.15); }),
					new LuiComboBoxItem({ text: "ELASTIC" }).setData("easeExample", easeExample).addEvent(LUI_EV_CLICK, function(e_) { 
						soup_store("dataeasetype", SCRIBBLE_EASE.ELASTIC); 
						var func_ = e_.getData("easeExample"); soup_store("dataease_tweenease", global.Ease.OutElastic); func_(); 
					}).addEvent(LUI_EV_MOUSE_ENTER, function(element_) { element_.color = c_yellow; element_.main_ui.animate(element_, "xoff", 5, 0.30, global.Ease.OutBack, 0); }).addEvent(LUI_EV_MOUSE_LEAVE, function(element_) { element_.color = c_white; element_.main_ui.animate(element_, "xoff", 0, 0.15); }),
					new LuiComboBoxItem({ text: "BOUNCE" }).setData("easeExample", easeExample).addEvent(LUI_EV_CLICK, function(e_) { 
						soup_store("dataeasetype", SCRIBBLE_EASE.BOUNCE); 
						var func_ = e_.getData("easeExample"); soup_store("dataease_tweenease", global.Ease.OutBounce); func_(); 
					}).addEvent(LUI_EV_MOUSE_ENTER, function(element_) { element_.color = c_yellow; element_.main_ui.animate(element_, "xoff", 5, 0.30, global.Ease.OutBack, 0); }).addEvent(LUI_EV_MOUSE_LEAVE, function(element_) { element_.color = c_white; element_.main_ui.animate(element_, "xoff", 0, 0.15); }),
				]),
				new LuiImage({ value: spr_soul, draw_normal: true }).setSize(20, 20).addEvent(LUI_EV_CREATE, function(e_) { soup_store("dataease_soul", e_); }),
			]),

			new LuiRow().setFlexGrow(1).centerContent().addContent([
				new LuiText({ value: "Start X Offset:", text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }).setTooltip("Changes where in the x position a\ntypewriter character starts at.", true),
				new LuiInput({ value: SYSTEMUI.typist_ease.x, placeholder: "123456", offset: 12, type_sfx: snd_txttype, color_normal: c_white, color_hover: c_gray, }).setPadding(20)
				.addEvent(LUI_EV_CREATE, function() { soup_store("dataease_x", SYSTEMUI.typist_ease.x); }).bindVariable(SYSTEMUI.typist_ease, "x")
				.addEvent(LUI_EV_VALUE_UPDATE, function(e_) { var value = real_ext(e_.get()), result = value == "" ? 0 : value; soup_store("dataease_x", result); }),
			]),
			
			new LuiRow().setFlexGrow(1).centerContent().addContent([
				new LuiText({ value: "Start Y Offset:", text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }).setTooltip("Changes where in the y position a\ntypewriter character starts at.", true),
				new LuiInput({ value: SYSTEMUI.typist_ease.y, placeholder: "123456", offset: 12, type_sfx: snd_txttype, color_normal: c_white, color_hover: c_gray, }).setPadding(20)
				.addEvent(LUI_EV_CREATE, function() { soup_store("dataease_y", SYSTEMUI.typist_ease.y); }).bindVariable(SYSTEMUI.typist_ease, "y")
				.addEvent(LUI_EV_VALUE_UPDATE, function(e_) { var value = real_ext(e_.get()), result = value == "" ? 0 : value; soup_store("dataease_y", result); }),
			]),
			
			new LuiRow().setFlexGrow(1).centerContent().addContent([
				new LuiText({ value: "Start X Scale:", text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }).setTooltip("Changes the starting xscale\nof a typewriter character.", true),
				new LuiInput({ value: SYSTEMUI.typist_ease.xscale, placeholder: "123456", offset: 12, type_sfx: snd_txttype, color_normal: c_white, color_hover: c_gray, }).setPadding(20)
				.addEvent(LUI_EV_CREATE, function() { soup_store("dataease_xs", SYSTEMUI.typist_ease.xscale); }).bindVariable(SYSTEMUI.typist_ease, "xscale")
				.addEvent(LUI_EV_VALUE_UPDATE, function(e_) { var value = real_ext(e_.get()), result = value == "" ? 0 : value; soup_store("dataease_xs", result); }),
			]),
			
			new LuiRow().setFlexGrow(1).centerContent().addContent([
				new LuiText({ value: "Start Y Scale:", text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }).setTooltip("Changes the starting yscale\nof a typewriter character.", true),
				new LuiInput({ value: SYSTEMUI.typist_ease.yscale, placeholder: "123456", offset: 12, type_sfx: snd_txttype, color_normal: c_white, color_hover: c_gray, }).setPadding(20)
				.addEvent(LUI_EV_CREATE, function() { soup_store("dataease_ys", SYSTEMUI.typist_ease.yscale); }).bindVariable(SYSTEMUI.typist_ease, "yscale")
				.addEvent(LUI_EV_VALUE_UPDATE, function(e_) { var value = real_ext(e_.get()), result = value == "" ? 0 : value; soup_store("dataease_ys", result); }),
			]),
			
			new LuiRow().setFlexGrow(1).centerContent().addContent([
				new LuiText({ value: "Smooth Alpha:", text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }).setTooltip("Changes the starting alpha\nof a typewriter character.\n0 - Characters will show up instantly\n1 - Characters will smoothly show up", true),
				new LuiSlider({ value: SYSTEMUI.typist_ease.alpha, min_value: 0, color_text: c_black, color_text_drag: c_white, max_value: 1, rounding: false, display_value: true, bar_sprite: spr_border_header, bar_sprite_back: spr_border_header, })
				.addEvent(LUI_EV_CREATE, function() { soup_store("dataease_alpha", SYSTEMUI.typist_ease.alpha); }).bindVariable(SYSTEMUI.typist_ease, "alpha")
				.addEvent(LUI_EV_VALUE_UPDATE, function(e_) { soup_store("dataease_alpha", real(e_.get())); }),
			]),
			
			new LuiRow().setFlexGrow(1).centerContent().addContent([
				new LuiText({ value: "Start Angle:", text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }).setTooltip("Changes the starting rotation\nof a typewriter character.", true),
				new LuiSlider({ value: SYSTEMUI.typist_ease.angle, min_value: 0, color_text: c_black, color_text_drag: c_white, max_value: 360, rounding: true, display_value: true, bar_sprite: spr_border_header, bar_sprite_back: spr_border_header, })
				.addEvent(LUI_EV_CREATE, function() { soup_store("dataease_angle", SYSTEMUI.typist_ease.angle); }).bindVariable(SYSTEMUI.typist_ease, "angle")
				.addEvent(LUI_EV_VALUE_UPDATE, function(e_) { soup_store("dataease_angle", real(e_.get())); soup_checkout("dataease_soul", false).angle = real(e_.get()); }),
			]),
			
			new LuiButton({ text: "Let's get soupy!!", height: 35, }).setData("tween", easeExample).addEvent(LUI_EV_CLICK, function(e_) {
				if ( soup_checkout("dataeasetype", false) == -1 ) { soupy_message("You must select an|easing type.", , 200, , , snd_error, , , true); exit; }
				
				var tween = e_.getData("tween"); tween(true);
				SYSTEMUI.typist_ease = { type: soup_checkout("dataeasetype"), x: soup_checkout("dataease_x"), y: soup_checkout("dataease_y"), xscale: soup_checkout("dataease_xs"), yscale: soup_checkout("dataease_ys"), angle: soup_checkout("dataease_angle"), alpha: soup_checkout("dataease_alpha"), };
				with ( SYSTEMUI ) { typist.ease(typist_ease.type, typist_ease.x, typist_ease.y, typist_ease.xscale, typist_ease.yscale, typist_ease.angle, typist_ease.alpha); }
				sfx_play(snd_chest); soup_checkout("datatypewriteredit_func")();
			}),
		];
		
		//typist_ease = { type: SCRIBBLE_EASE.LINEAR, x: 0, y: 0, xscale: 1, yscale: 1, angle: 0, alpha: 1, };
		//typist.ease(typist_ease.type, typist_ease.x, typist_ease.y, typist_ease.xscale, typist_ease.yscale, typist_ease.angle, typist_ease.alpha);
		
		soup_store("dataeasetype", -1); 
		soup_store("datatypewriteredit_func", function() { soup_checkout("datatypewriteredit").destroy(); soup_store_clear(); SYSTEMUI.ui_paused = false; });
		var maincan = soupy_popup(dataarr, function() { soup_store_clear(); SYSTEMUI.ui_paused = false; }, "Nevermind", , , , , , , 2); soup_store("datatypewriteredit", maincan); 
	}
#endregion

