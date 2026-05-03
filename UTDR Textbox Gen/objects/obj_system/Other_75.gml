///@desc External Sprites
//if ( live_call() ) { return live_result; }
var async_result = async_load;

#region Dropping Files
	if ( UI_MESSAGE ) {
		var fpath = async_result[?"filename"], _is_microsoft = ( os_type == os_windows || os_type == os_xboxseriesxs || os_type == os_gdk ), _path_separator = _is_microsoft? "\\"  :  "/";
		if ( async_result[?"event_type"] == "file_drop" && fpath != undefined ) {
			var fname = filename_name(fpath), fext = filename_ext(fpath);
			var temp_ = string_replace(string_replace(fname, $"_strip", ""), $".png", "");
			var finalname = string_exclude(temp_, "0123456789");

			show_debug_message($"File Path: {fpath}\nFile Name: {fname}\nFile Type: {fext}\nFinal Name: {finalname}");
			if ( bord_visible && ( range_within(mouse_x_gui, 0, 174) && range_within(mouse_y_gui, 323, 480) ) ) { //Hovering over the dialogue portrait
				if ( fext == ".png" ) {
					if ( struct_exists(global.faces_dict_alt, finalname) ) { dial_face[dial_text_page] = get_face(finalname); dial_face_original[dial_text_page] = dial_face[dial_text_page]; sfx_play(snd_bump, , 0.7, 1.5); sfx_play(snd_sparkle); } //If this sprite already exists within our face dictonary, just set the current page's face to that
					else {
						#region Sprite Doesn't Exist Message
							#region Yes Button
								var panel_bg_ = new LuiBox({ x: 0, y: 0, }).centerContent().setPositionAbsolute().bringToFront().setFullSize(); //Fullscreen opaque box
								var panel_ = new LuiPanel({ allow_resize: true, width: 320, height: 170, }); //Container for text, yes, and no 
								var panel_yes_ = new LuiButton({ text: "Yes!" }).setData("panel_bg_", panel_bg_).setData("fname", fname).setData("fpath", fpath).setData("finalname", finalname).addEvent(LUI_EV_CLICK, function(element_) {
									var get_panel_ = element_.getData("panel_bg_");
					
									var fname = element_.getData("fname"), fpath = element_.getData("fpath"), myname = element_.getData("finalname");
									if ( !struct_exists(global.faces_dict, myname) ) { global.faces_dict[$ myname] = {}; } //Create new struct face dictionary
									var imgnum = string_digits(fname); imgnum = imgnum != "" ? real(imgnum) : 1; //Get number of images in this sprite
									with ( global.faces_dict[$ myname] ) {
										var finalname = string_replace(string_replace(fname, "_strip", ""), ".png", ""); finalname = string_exclude(finalname, "0123456789");

										self[$ "DEFAULT CUSTOM SOUPY"] = { sprite: sprite_add_ext(fpath, imgnum, 0, 0, true), expression: finalname, name: fpath, } //Add sprite and data
										soup_store("external face", { myname, id_: "DEFAULT CUSTOM SOUPY", });
										with ( self[$ "DEFAULT CUSTOM SOUPY"] ) { 
											self[$ "destroy"] = function () { sprite_delete(sprite); delete sprite; sprite = -1; show_debug_message($"External face \"{name}\" was destroyed and freed from memory successfully!"); } //Add a destroy func so we don't get memory leaks
							
											var out_ = $"Added \"{expression}\"|You can now use|[{expression}] and [face,{expression}]|to reference the sprite!|The command was copied to your clipboard.";
											soup_store_stock("external face", "msg", out_);
											if ( !scribble_external_sprite_exists(finalname) ) { scribble_external_sprite_add(sprite, finalname); } //Add sprite to Scribble
											var altname = string_replace(finalname, "spr_", "");
											if ( !scribble_external_sprite_exists(altname) ) { scribble_external_sprite_add(sprite, altname); } //Add alternative name
											global.faces_dict_alt[$ myname] = { sprite, expression, name, destroy, } //Create new struct face dictionary
											clipboard_set_text($"[{expression}][face,{expression}]");
										}
									}
									get_panel_.container.destroy();
									obj_system.ui_paused = false;
								});
							#endregion
				
							#region No Button
								var panel_no_ = new LuiButton({ text: "No." }).setData("panel_bg_", panel_bg_).addEvent(LUI_EV_CREATE, function(element_) { sfx_play(snd_equip); }).addEvent(LUI_EV_CLICK, function(element_) {
									var get_panel_ = element_.getData("panel_bg_");
									get_panel_.container.destroy(); 
									obj_system.ui_paused = false;
									sfx_play(snd_cancel);
								});
							#endregion
							panel_.addContent([
								new LuiColumn().addContent(new LuiText({ value: "This sprite doesn't exist within our\nface dictionary. Would you like to\nadd this as a new face sprite?", text_halign: fa_center, y: 10 })),
								new LuiColumn().setFlexGrow(1).setFlexJustifyContent(flexpanel_justify.flex_end).addContent([ panel_yes_, panel_no_, ]),
							]);
							soupy_lui.addContent(panel_bg_.addContent(panel_));
							obj_system.ui_paused = true;
						#endregion
					}
				}
				else { soupy_message($"\"{fname}\"|is not allowed to be loaded.|File must be a PNG format.", , 320); }
			}
			else if ( ui_tab == 0 && ( range_within(mouse_x_gui, 0, 640) && range_within(mouse_y_gui, 120, bord_visible ? 300 : 380) ) ) { //Hovering over the textbox
				var fext = filename_ext(fpath);
				if ( fext != ".txt" ) { soupy_message($"\"{fname}\"|is not allowed to be loaded.|File must be a TXT format.", , 320); }
				else { 
					var result = buffer_load(fpath), txt = buffer_read(result, buffer_text);
					buffer_delete(result);
					dial_text_page = 0;
					textinput.SetValue(txt);
					obj_system.dial_updatet = 1;
					sfx_play(snd_equip2);
				}
			}
			else if ( bord_visible && ( range_within(mouse_x_gui, 190, 640) && range_within(mouse_y_gui, 315, 480) ) ) { //Hovering over the dialogue border
				if ( fext == ".png" ) {
					if ( struct_exists(global.bords_dict_alt, finalname) ) { spr_bord = get_border(finalname); bord_prev = spr_bord; if ( bord_spd == 0 ) { bord_spd = 0.15; } bord_anim = 0; sfx_play(snd_bump, , 0.7, 1.5); sfx_play(snd_sparkle); } //If this sprite already exists within our border dictonary, just set the current border to that
					else {
						#region Sprite Doesn't Exist Message
							#region Yes Button
								var panel_bg_ = new LuiBox({ x: 0, y: 0, }).centerContent().setPositionAbsolute().bringToFront().setFullSize(); //Fullscreen opaque box
								var panel_ = new LuiPanel({ allow_resize: true, width: 320, height: 170, }); //Container for text, yes, and no 
								var panel_yes_ = new LuiButton({ text: "Yes!" }).setData("panel_bg_", panel_bg_).setData("fname", fname).setData("fpath", fpath).setData("finalname", finalname).addEvent(LUI_EV_CLICK, function(element_) {
									var get_panel_ = element_.getData("panel_bg_");
					
									var fname = element_.getData("fname"), fpath = element_.getData("fpath"), myname = element_.getData("finalname");
									if ( !struct_exists(global.bords_dict, myname) ) { global.bords_dict[$ myname] = {}; } //Create new struct border dictionary
									var imgnum = string_digits(fname); imgnum = imgnum != "" ? real(imgnum) : 1; //Get number of images in this sprite
									with ( global.bords_dict[$ myname] ) {
										var finalname = string_replace(string_replace(fname, "_strip", ""), ".png", ""); finalname = string_exclude(finalname, "0123456789");

										self[$ "sprite"] = sprite_add_ext(fpath, imgnum, 0, 0, true); self[$ "name"] = fpath; self[$ "destroy"] = function () { sprite_delete(sprite); delete sprite; sprite = -1; show_debug_message($"External border \"{name}\" was destroyed and freed from memory successfully!"); } //Add a destroy func so we don't get memory leaks
										soup_store("external border", { myname });
							
										var out_ = $"Added \"{finalname}\"|You can now use|[border,{finalname}]|to reference the sprite!|The command was copied to your clipboard.";
										soup_store_stock("external border", "msg", out_);
										global.bords_dict_alt[$ myname] = { sprite, name, destroy } //Create new struct border dictionary
										clipboard_set_text($"[border,{finalname}]");
									}
									get_panel_.container.destroy(); 
									obj_system.ui_paused = false;
								});
							#endregion
				
							#region No Button
								var panel_no_ = new LuiButton({ text: "No." }).setData("panel_bg_", panel_bg_).addEvent(LUI_EV_CREATE, function(element_) { sfx_play(snd_equip); }).addEvent(LUI_EV_CLICK, function(element_) {
									var get_panel_ = element_.getData("panel_bg_");
									get_panel_.container.destroy(); 
									obj_system.ui_paused = false;
									sfx_play(snd_cancel);
								});
							#endregion
							panel_.addContent([
								new LuiColumn().addContent(new LuiText({ value: "This sprite doesn't exist within\nour borders dictionary. Would you\n like to add this as a\nnew dialogue border sprite?", text_halign: fa_center, y: 10 })),
								new LuiColumn().setFlexGrow(1).setFlexJustifyContent(flexpanel_justify.flex_end).addContent([ panel_yes_, panel_no_, ]),
							]);
							soupy_lui.addContent(panel_bg_.addContent(panel_));
							obj_system.ui_paused = true;
						#endregion
					}
				}
				else { soupy_message($"\"{fname}\"|is not allowed to be loaded.|File must be a PNG format.", , 320); }
			}
			else { soupy_message("No drop zone detected."); }
		}
	}
	if ( async_result[?"event_type"] == "file_drag_over" ) { file_dragging = true; if ( !UI_MESSAGE ) { file_dropper_set_effect(file_dropper_effect_none); } } //For dragging files onto the screen
	if ( async_result[?"event_type"] == "file_drop_end" || async_result[?"event_type"] == "file_drag_leave" ) { file_dragging = false; } //For either the user drags files out of the screen or the drop event has ended
#endregion
