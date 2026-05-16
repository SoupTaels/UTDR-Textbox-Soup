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
				self[$ "size"] = { sprite, width: sprite_get_width(sprite), height: sprite_get_height(sprite), }
				sprite_set_offset(sprite, size.width/ 2, size.height/ 2); //Center sprite
				
				var out_ = $"Added \"{name}\" from {fname_}! Image Count: {count}";
				scribble_external_sprite_add(sprite, name);
				
				var temp_2 = string_replace(icons_cur, $"icons{_path_separator}", ""); 
				temp_2 = string_replace(string_replace(temp_2, $"_strip", ""), $".png", "");
				temp_2 = string_exclude(temp_2, "0123456789");
				if ( !scribble_external_sprite_exists(temp_2) ) { scribble_external_sprite_add(sprite, temp_2); } //alternative
				global.icons_dict_alt[$ temp_2] = { sprite, name, size, } //Add sprite index and expression name to the global icon alt dictonary
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
				self[$ "size"] = { sprite, width: sprite_get_width(sprite), height: sprite_get_height(sprite), }
				sprite_set_offset(sprite, size.width/ 2, size.height/ 2); //Center sprite
				
				var out_ = $"Added \"{name}\" from {fname_}! | Image Count: {count}";
				var temp_2 = string_replace(bords_cur, $"borders{_path_separator}", ""); 
				temp_2 = string_replace(string_replace(temp_2, $"_strip", ""), $".png", "");
				temp_2 = string_exclude(temp_2, "0123456789");
				global.bords_dict_alt[$ temp_2] = { sprite, name, size, } //Add sprite index and expression name to the global icon alt dictonary
				show_debug_message(out_); global.outputLog += $"{out_}\n";
			}
		bords_i++; }
		
		///@desc Returns a sprite index from an externally added border sprite.
		///@param {string} name Border Sprite Name (ex: spr_border_custom_animated, border custom example, border_custom_example_two, etc.)
		function get_border(name, return_ = "sprite") { 
			var early_ = asset_get_index(name); if ( early_ != -1 ) { return early_; }
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
		var early_ = asset_get_index(name); if ( early_ != -1 ) { return early_; }
		var result = global.fonts_dict[$ name], result2 = global.fonts_dict_alt[$ name];
		var temp_ = string_replace_all(name, " ", "_"), result3 = global.fonts_dict[$ temp_]
		return !is_undefined(result) ? result[$ return_] : ( !is_undefined(result2) ? result2[$ return_] : ( !is_undefined(result3) ? result3[$ return_] : -1 ) );
	}
#endregion

#region Log
	var oLog = file_text_open_write($"{executable_get_directory()}latest_soupy_run.txt");
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
					if ( !struct_exists(global.faces_dict, name_) ) { global.faces_dict[$ name_] = {}; } //Create new struct face dictionary
					with ( global.faces_dict[$ name_] ) {
						var finalname = string_replace(string_replace(fname_, "_strip", ""), ".png", ""); finalname = string_exclude(finalname, "0123456789");

						self[$ "NEW SPRITE"] = true; //Mark the sprite as new
						self[$ "DEFAULT CUSTOM SOUPY"] = { sprite: sprite_add_ext(fpath_, imgnum, 0, 0, true), expression: finalname, name: fpath_, } //Add sprite and data
						if ( allowmultiple_ ) { soup_store("allowmultiple"); }
						soup_store("external face", { myname: name_, id_: "DEFAULT CUSTOM SOUPY", });
						with ( self[$ "DEFAULT CUSTOM SOUPY"] ) { 
							self[$ "destroy"] = function () { sprite_delete(sprite); delete sprite; sprite = -1; show_debug_message($"External face \"{name}\" was destroyed and freed from memory successfully!"); } //Add a destroy func so we don't get memory leaks
							
							var out_ = $"Added \"{expression}\"|You can now use|[{expression}] and [face,{expression}]|to reference the sprite!|The command was copied to your clipboard.";
							soup_store_stock("external face", "msg", out_);
							if ( !scribble_external_sprite_exists(finalname) ) { scribble_external_sprite_add(sprite, finalname); } //Add sprite to Scribble
							var altname = string_replace(finalname, "spr_", "");
							if ( !scribble_external_sprite_exists(altname) ) { scribble_external_sprite_add(sprite, altname); } //Add alternative name
							global.faces_dict_alt[$ name_] = { sprite, expression, name, destroy, } //Create new struct face dictionary
							clipboard_set_text($"[{expression}][face,{expression}]");
							return sprite;
						}
					}
				}
			} break;
			
			case 1: { //Border Sprites
				var spr_ = get_border(name_);
				if ( spr_ != -1 ) { return spr_; } else {
					if ( !struct_exists(global.bords_dict, name_) ) { global.bords_dict[$ name_] = {}; } //Create new struct border dictionary
					var imgnum = string_between(fname_, "_strip", ".png"); imgnum = imgnum == "" ? 1 : imgnum; //Get the image number if it's a strip file
					with ( global.bords_dict[$ name_] ) {
						var finalname = string_replace(string_replace(fname_, "_strip", ""), ".png", ""); finalname = string_exclude(finalname, "0123456789");

						self[$ "sprite"] = sprite_add_ext(fpath_, imgnum, 0, 0, true); self[$ "name"] = fpath_; self[$ "destroy"] = function () { sprite_delete(sprite); delete sprite; sprite = -1; show_debug_message($"External border \"{name}\" was destroyed and freed from memory successfully!"); } //Add a destroy func so we don't get memory leaks
						if ( allowmultiple_ ) { soup_store("allowmultiple"); }
						soup_store("external border", { myname: name_ });
							
						var out_ = $"Added \"{finalname}\"|You can now use|[border,{finalname}]|to reference the sprite!|The command was copied to your clipboard.";
						soup_store_stock("external border", "msg", out_);
						global.bords_dict_alt[$ name_] = { sprite, name, destroy } //Create new struct border dictionary
						clipboard_set_text($"[border,{finalname}]");
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
				new LuiText({ value: isnew_ != undefined && isnew_ ? $"{string_upper_first(cur_)} (NEW!)" : string_upper_first(cur_), id_: cur_, font: fnt_speech, text_halign: fa_center, text_valign: fa_middle, color: ( get_face(cur_) != -1 ? c_cyan : c_white ), }).setPadding(5).setData("chara", cur_).setTooltip(get_face(cur_) != -1 ? $"[{cur_}] [rainbow]Added via dragging!" : "", true, , true)
				.setData("inputsoup_", inputsoup_).setData("inputglobal_", inputglobal_).setData("imagesoup_", imagesoup_).setData("imageglobal_", imageglobal_).setData("clear_", clear_)
				.addEvent(LUI_EV_MOUSE_ENTER, function(element_) { element_.color = c_yellow; sfx_play(snd_sel_switch); element_.main_ui.animate(element_, "xoff", 10, 0.30, global.Ease.OutBack, 0); })
				.addEvent(LUI_EV_MOUSE_LEAVE, function(element_) { element_.color = get_face(element_.params.id_) != -1 ? c_cyan : c_white; element_.main_ui.animate(element_, "xoff", 0, 0.15); })
				.addEvent(LUI_EV_CLICK, function(element_) { //Once clicked on, create new scroll panel and populate it with face sprites
					var get_ = soup_checkout("scrollmain", false); soup_checkout("scrollsub", false).destroy(); 
					global.faces_dict[$ element_.params.id_][$ "NEW SPRITE"] = false; sfx_play(snd_select);
					//Exit early if the sprite already exists(for external sprites added through drag & drop)
					var early_ = get_face(element_.params.id_); if ( sprite_exists(early_) ) { sfx_play(snd_updated); if ( element_.getData("clear_") ) { FACE_CURRENT = early_; FACE_ORIGINAL = FACE_CURRENT; } soup_checkout(element_.getData("inputsoup_"), false, element_.getData("inputglobal_")).set(element_.params.id_); soup_checkout(element_.getData("imagesoup_"), false, element_.getData("imageglobal_")).set(element_.getData("face")); soup_checkout("datafunc", false)(); exit; }
					
					var spr_ = [], cur_ = element_.getData("chara"), spr_exp = struct_get_names(global.faces_dict[$ cur_]), spr_len = array_length(spr_exp), spr_i = 0; //Folders filled with sprites will have their sprites shown here
					repeat ( spr_len ) {
						var exp_ = spr_exp[spr_i], finalname = $"spr_{cur_}_{exp_}", myspr = get_face(finalname);
						if ( exp_ != "NEW SPRITE" ) {
							array_push(spr_, new LuiImageButton({ value: myspr, draw_normal: true, }).setSize(sprite_get_width(myspr), sprite_get_height(myspr)).setData("face", myspr).setData("facename", finalname).setFlexAlignSelf(flexpanel_align.center).setTooltip($"{finalname}\n[face,{finalname}]", true)
							.setData("inputsoup_", element_.getData("inputsoup_")).setData("inputglobal_", element_.getData("inputglobal_")).setData("imagesoup_", element_.getData("imagesoup_")).setData("imageglobal_", element_.getData("imageglobal_")).setData("clear_", element_.getData("clear_"))
							.addEvent(LUI_EV_CLICK, function(element_) { sfx_play(snd_updated); if ( element_.getData("clear_") ) { FACE_CURRENT = element_.getData("face"); FACE_ORIGINAL = FACE_CURRENT; } soup_checkout(element_.getData("inputsoup_"), false, element_.getData("inputglobal_")).set(element_.getData("facename")); soup_checkout(element_.getData("imagesoup_"), false, element_.getData("imageglobal_")).set(element_.getData("face")); soup_checkout("datafunc", false)(); })
							);
						}
					spr_i++; }
					get_.addContent(new LuiScrollPanel({ height: 400, scroll_pin_edge_offset:10, sprite_panel: false, }).addContent(spr_).addEvent(LUI_EV_CREATE, function(element_) { soup_store("scrollsub", element_); })); //Add new panel and stash it so we can destroy it later
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
			array_push(options_, new LuiText({ value: "Clear Page Face", font: fnt_speech, text_halign: fa_center, text_valign: fa_middle, }).setPadding(5)
				.setData("inputsoup_", inputsoup_).setData("inputglobal_", inputglobal_).setData("imagesoup_", imagesoup_).setData("imageglobal_", imageglobal_).setData("clear_", clear_)
				.addEvent(LUI_EV_MOUSE_ENTER, function(element_) { element_.color = c_red; sfx_play(snd_sel_switch); element_.main_ui.animate(element_, "xoff", 10, 0.30, global.Ease.OutBack, 0); })
				.addEvent(LUI_EV_MOUSE_LEAVE, function(element_) { element_.color = c_white; element_.main_ui.animate(element_, "xoff", 0, 0.15); })
				.addEvent(LUI_EV_CLICK, function(element_) { sfx_play(snd_hurtpowerful); if ( element_.getData("clear_") ) { FACE_CURRENT = -1; FACE_ORIGINAL = FACE_CURRENT; } soup_checkout(element_.getData("inputsoup_"), false, element_.getData("inputglobal_")).set(-1); soup_checkout(element_.getData("imagesoup_"), false, element_.getData("imageglobal_")).set(""); soup_checkout("datafunc", false)(); })
			);
		#endregion

		var dataarr = [
			new LuiRow().setFlexGrow(1).centerContent().addContent([
				new LuiScrollPanel({ height: 400, scroll_pin_edge_offset:10, sprite_panel: false, }).addContent(options_),
				new LuiText({ value: $"Select a character!\n\nFaces will show up once\nselected. Then scroll to\nfind the perfect sprite\nfor your dialogue!\n\nThis only adds a face for\nthe current dialogue page.", font: fnt_speech, text_halign: fa_center, text_valign: fa_center, }).addEvent(LUI_EV_CREATE, function(element_) { soup_store("scrollsub", element_); }),
			]).addEvent(LUI_EV_CREATE, function(element_) { soup_store("scrollmain", element_); }), //Stash panel so we can add another panel to this row
		];
		
		soup_store("datafunc", method({ clear_, }, function() { soup_checkout("choosemain", false).destroy(); if ( clear_ ) { soup_store_clear(); SYSTEMUI.ui_paused = false; } }));
		var maincan = soupy_popup(dataarr, method({ clear_ }, function() { if ( clear_ ) { soup_store_clear();  SYSTEMUI.ui_paused = false; } }), "Nevermind", , , , snd_select, , multiple_, 2); soup_store("choosemain", maincan); 
	}
#endregion