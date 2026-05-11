///@desc External Sprites
//if ( live_call() ) { return live_result; }
if ( !ui_visible ) { exit; } //Don't want to allow file dragging while we're exporting
var async_result = async_load;
var fpath = async_result[? "filename"], _is_microsoft = ( os_type == os_windows || os_type == os_xboxseriesxs || os_type == os_gdk ), _path_separator = _is_microsoft? "\\"  :  "/";
var fname = filename_name(fpath), fext = filename_ext(fpath);
var temp_ = string_replace(string_replace(fname, $"_strip", ""), $".png", "");
var finalname = string_exclude(temp_, "0123456789");
show_debug_message($"File Path: {fpath}\nFile Name: {fname}\nFile Type: {fext}\nFinal Name: {finalname}");

#region Dropping Files
	if ( UI_MESSAGE ) {
		if ( async_result[?"event_type"] == "file_drop" && fpath != undefined ) {
			if ( bord_visible && ( range_within(mouse_x_gui, 0, 174) && range_within(mouse_y_gui, 323, 480) ) ) { //Hovering over the dialogue portrait
				if ( fext == ".png" ) {
					if ( struct_exists(global.faces_dict_alt, finalname) ) { FACE_CURRENT = get_face(finalname); FACE_ORIGINAL = FACE_CURRENT; FACE_INTERNAL = finalname; sfx_play(snd_bump, , 0.7, 1.5); sfx_play(snd_sparkle); } //If this sprite already exists within our face dictonary, just set the current page's face to that
					else {
						#region Sprite Doesn't Exist Message
							#region Yes Button
								var panel_bg_ = new LuiBox({ x: 0, y: 0, }).centerContent().setPositionAbsolute().bringToFront().setFullSize(); //Fullscreen opaque box
								var panel_ = new LuiPanel({ allow_resize: true, width: 320, height: 170, }); //Container for text, yes, and no 
								var panel_yes_ = new LuiButton({ text: "Yes!" }).setData("panel_bg_", panel_bg_).setData("fname", fname).setData("fpath", fpath).setData("finalname", finalname).addEvent(LUI_EV_CLICK, function(element_) {
									var get_panel_ = element_.getData("panel_bg_");
					
									var fname = element_.getData("fname"), fpath = element_.getData("fpath"), myname = element_.getData("finalname");
									external_ensure(myname, fname, fpath, , false);
									get_panel_.container.destroy();
									SYSTEMUI.ui_paused = false;
								});
							#endregion
				
							#region No Button
								var panel_no_ = new LuiButton({ text: "No." }).setData("panel_bg_", panel_bg_).addEvent(LUI_EV_CREATE, function(element_) { sfx_play(snd_equip); }).addEvent(LUI_EV_CLICK, function(element_) {
									var get_panel_ = element_.getData("panel_bg_");
									get_panel_.container.destroy(); 
									SYSTEMUI.ui_paused = false;
									sfx_play(snd_cancel);
								});
							#endregion
							panel_.addContent([
								new LuiColumn().addContent(new LuiText({ value: "This sprite doesn't exist within our\nface dictionary. Would you like to\nadd this as a new face sprite?", text_halign: fa_center, y: 10 })),
								new LuiColumn().setFlexGrow(1).setFlexJustifyContent(flexpanel_justify.flex_end).addContent([ panel_yes_, panel_no_, ]),
							]);
							soupy_lui.addContent(panel_bg_.addContent(panel_));
							SYSTEMUI.ui_paused = true;
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
					SYSTEMUI.dial_updatet = 1;
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
									external_ensure(myname, fname, fpath, 1, false);
									get_panel_.container.destroy(); 
									SYSTEMUI.ui_paused = false;
								});
							#endregion
				
							#region No Button
								var panel_no_ = new LuiButton({ text: "No." }).setData("panel_bg_", panel_bg_).addEvent(LUI_EV_CREATE, function(element_) { sfx_play(snd_equip); }).addEvent(LUI_EV_CLICK, function(element_) {
									var get_panel_ = element_.getData("panel_bg_");
									get_panel_.container.destroy(); 
									SYSTEMUI.ui_paused = false;
									sfx_play(snd_cancel);
								});
							#endregion
							panel_.addContent([
								new LuiColumn().addContent(new LuiText({ value: "This sprite doesn't exist within\nour borders dictionary. Would you\n like to add this as a\nnew dialogue border sprite?", text_halign: fa_center, y: 10 })),
								new LuiColumn().setFlexGrow(1).setFlexJustifyContent(flexpanel_justify.flex_end).addContent([ panel_yes_, panel_no_, ]),
							]);
							soupy_lui.addContent(panel_bg_.addContent(panel_));
							SYSTEMUI.ui_paused = true;
						#endregion
					}
				}
				else { soupy_message($"\"{fname}\"|is not allowed to be loaded.|File must be a PNG format.", , 320); }
			}
			else { soupy_message("No drop zone detected."); }
		}
		
		if ( async_result[?"event_type"] == "file_drag_over" ) { file_dragging = true; if ( !UI_MESSAGE ) { file_dropper_set_effect(file_dropper_effect_none); } } //For dragging files onto the screen
		if ( async_result[?"event_type"] == "file_drop_end" || async_result[?"event_type"] == "file_drag_leave" ) { file_dragging = false; } //For either the user drags files out of the screen or the drop event has ended
	}
	else {
		if ( async_result[?"event_type"] == "file_drop" && fpath != undefined ) {
			if ( ui_tab == 0 && soup_checkout("minimain", false) != undefined ) { //On the mini dialogue popup
				var result = external_ensure(finalname, fname, fpath);
				if ( !is_undefined(soup_checkout("minimain", false)) ) { if ( result != -1 ) { soup_checkout("minifind", false).setSprite(result); soup_store("minisprite", finalname); } }
			}
			else { soupy_message("No drop zone detected.", , , , , , , , true); }
		}
	}
#endregion
