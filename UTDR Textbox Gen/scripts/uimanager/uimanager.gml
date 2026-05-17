#macro SYSTEMUI obj_system //System object
#macro UI_MESSAGE !SYSTEMUI.ui_paused //For pausing ui elements
#macro FACE_CURRENT obj_system.dial_face[obj_system.dial_text_page] //Get the current dialogue face
#macro FACE_INDEX obj_system.dial_face_index[obj_system.dial_text_page]
#macro FACE_ORIGINAL obj_system.dial_face_original[obj_system.dial_text_page] //Get the original dialogue face
#macro FACE_PREVIOUS obj_system.dial_face_prev[obj_system.dial_text_page] //Get the previous dialogue face
#macro FACE_INTERNAL obj_system.dial_face_name[obj_system.dial_text_page] //Get the internal name for the current dialogue face
#macro FACE_USING FACE_CURRENT != -1 && FACE_CURRENT != 0 //If the dialogue box will contain a face
#macro LAST_SAVED $"{executable_get_directory()}latest_soupy_last_typed.soupy" //Last text we typed

#region Default functions for the menu buttons
	function on_enter_() { if ( SYSTEMUI.ui_tab != id_ ) { sfx_play(snd_sel_switch); TweenFire("~ocirc", "$15", "yoff>", 5); text = $"[c_yellow][wheel]{text_static}"; color_butt = c_yellow; } }
	function on_leave_() { if ( SYSTEMUI.ui_tab != id_ ) { TweenFire("~ocirc", "$15", "yoff>", 0); text = text_static; color_butt = c_orange; } window_set_cursor(cr_default); }
	function on_click_() { if ( SYSTEMUI.ui_tab != id_ ) { sfx_play(snd_select); SYSTEMUI.ui_tab = id_; on_reset_(); } else { sfx_play(snd_bump, , , random_range(0.8, 1.2)); } }
	function on_hover_() { window_set_cursor(cr_drag); }
	function on_reset_() { 
		if ( !instance_exists(SYSTEMUI) ) { exit; }
		SYSTEMUI.ui_reset();
		
		var i = 0;
		repeat ( array_length(SYSTEMUI.butt) ) { with ( SYSTEMUI.butt[i].data ) { if ( SYSTEMUI.ui_tab != id_ ) { TweenFire("~ocirc", "$15", "yoff>", 0); text = text_static; color_butt = c_orange; } else { TweenFire("~ocirc", "$15", "yoff>", 5); text = $"[c_yellow][wheel]{text_static}"; color_butt = c_yellow; } } i++; }
	}
#endregion

#region Context Menu Functions
	///@desc Clears all text in the textbox
	function soupy_context_clear() { textinput.SetValue(""); sfx_play(snd_throw); dial_updatet = 1; }
	
	///@desc Inserts a page break in the textbox
	function soupy_context_page() { 
		var txt_ = textinput.GetValue(), cursor_ = textinput.GetCaret() + 1, insert_ = "[/page]";
		txt_ = string_insert(insert_, txt_, cursor_); textinput.SetValue(txt_);
		sfx_play(snd_bump); dial_updatet = 1; textinput.SetCaret(( cursor_ + string_length(insert_) ) - 1); 
	}
#endregion

function TextChange(txt, point) : UndoableChange() constructor { //Handle undo/ redoing changes
	live_auto_call
	prev_txt = SYSTEMUI.dial_text; //Store previous/ inital text
	point_prev = SYSTEMUI.textinput.GetCaret(); //Get previous point
	mytxt = txt; //Get our new text
	point_ = point; //Get our new point

	static can_apply = function() { return ( SYSTEMUI.dial_text != mytxt ); } //Don't push the same unchanged text to the undo stack
	static apply = function() { with ( obj_system ) { //Apply recent changes
		dial_text = other.mytxt; 
		textinput.SetValue(dial_text);
		
		var lasttyped = file_text_open_write(LAST_SAVED);
		file_text_write_string(lasttyped, dial_text); //Save what the user last typed
		file_text_close(lasttyped);
		
		textinput.SetCaret(other.point_); } 
		sfx_play(snd_updated); 
	}
    static undo = function() { with ( obj_system ) { dial_text = other.prev_txt; textinput.SetValue(dial_text); textinput.SetCaret(other.point_prev); } sfx_play(snd_throw); }
}

///@desc Create a GUI button. Accepts { x, y, text, padd_(x1, y1, x2, y2, multi), leeway, x2, y2, sprite, draw_nine, index, (x)(y)scale, angle, font, color, color_butt, halign, and valign, and functions for on_enter(runs once), on_hover, on_leave(once), on_click(once), on_held, on_released(once) }
///@param {struct} datastruct_ Data struct for button functionality.
function Button(datastruct_ = undefined) constructor {
	data = datastruct_; button = undefined; on_enter = false; on_leave = false;
	if ( is_undefined(data[$ "text"]) ) { data[$ "text"] = ""; }
	data[$ "text_static"] = data.text;

	static update = function() {
		var y2pd = data[$ "padd_y2"] ?? 0, x2pd = data[$ "padd_x2"] ?? 0, y1pd = data[$ "padd_y1"] ?? 0, x1pd = data[$ "padd_x1"] ?? 0, paddmulti = data[$ "padd_multi"] ?? 0, hastext = data.text != "";
		if ( hastext ) {
		button = scribble(data.text)
						.align(data[$ "halign"] ?? fa_center, data[$ "valign"] ?? fa_middle)
						.starting_format(data[$ "font"] ?? "fnt_determination_nomono", data[$ "color"] ?? c_white)
						.scale(data[$ "scale"] ?? 1)
						.padding(x1pd + paddmulti, y1pd + paddmulti, x2pd + paddmulti, y2pd + paddmulti);
		}
			
		var spr_ = data[$ "sprite"] ?? spr_pixel, index = data[$ "index"] ?? 0, clrbutt = data[$ "color_butt"] ?? c_white, clrbutthovered = data[$ "color_butt_hover"] ?? data.color_butt, angle = data[$ "angle"] ?? 1, xscale = data[$ "xscale"] ?? 1, yscale = data[$ "yscale"] ?? 1, scalemulti = data[$ "scale"] ?? 1, x_ = data[$ "x"] ?? 0, y_ = data[$ "y"] ?? 0, x2_ = data[$ "x2"] ?? 0, y2_ = data[$ "y2"] ?? 0, xoff = data[$ "xoff"] ?? 0, yoff = data[$ "yoff"] ?? 0, bbox = hastext ? button.get_bbox(x_, y_) : ({ left: x_, top: y_, right: x2_, bottom: y2_, width: x2_ - x_, height: y2_ - y_ }), leeway = data[$ "leeway"] ?? 5;
		var visible_ = data[$ "draw_nine"] ?? true;
		var hovered = range_within(mouse_x_gui, bbox.left - leeway, bbox.right + leeway) && range_within(mouse_y_gui, bbox.top - leeway, bbox.bottom + leeway);
		if ( visible_ ) { draw_sprite_stretched_ext(spr_, index, bbox.left + xoff, bbox.top + yoff, bbox.width, bbox.height, !hovered ? clrbutt : clrbutthovered, 1); } //Draw nine-slice sprite
		else { draw_sprite_ext(spr_, index, bbox.left + xoff, bbox.top + yoff, xscale * scalemulti, yscale * scalemulti, angle, !hovered ? clrbutt : clrbutthovered, 1); } //Draw normal sprite
		if ( hastext ) { button.draw(x_ + xoff, y_ + yoff); } //Draw Scribble text
			
		if ( hovered && window_has_focus() ) { //If the mouse has enter within the bounding box
			if ( UI_MESSAGE ) { 
				if ( !on_enter ) { on_enter = true; on_leave = false; if ( !is_undefined(data[$ "on_enter"]) && data[$ "on_enter"] != -1 ) { data[$ "on_enter"](); } } //Mouse Entered Function
				if ( !is_undefined(data[$ "on_hover"]) && data[$ "on_hover"] != -1 ) { data[$ "on_hover"](); } //Mouse Hovering Function
				if ( mouse_pressed && !is_undefined(data[$ "on_click"]) && data[$ "on_click"] != -1 ) { data[$ "on_click"](); exit; } //Mouse Pressed Function
				if ( mouse_check && !is_undefined(data[$ "on_held"]) && data[$ "on_held"] != -1 ) { data[$ "on_held"](); } //Mouse Held Function
				if ( mouse_released && !is_undefined(data[$ "on_released"]) && data[$ "on_released"] != -1) { data[$ "on_released"](); } //Mouse Released Function
				if ( mouse_pressed_right && !is_undefined(data[$ "on_click_right"]) && data[$ "on_click_right"] != -1 ) { data[$ "on_click_right"](); exit; } //Mouse Pressed Function
				if ( mouse_check_right && !is_undefined(data[$ "on_held_right"]) && data[$ "on_held_right"] != -1 ) { data[$ "on_held_right"](); } //Mouse Held Function
				if ( mouse_released_right && !is_undefined(data[$ "on_released_right"]) && data[$ "on_released_right"] != -1 ) { data[$ "on_released_right"](); } //Mouse Released Function
			}
		}
		else { //If the mouse just left the bounding box
			if ( on_enter ) { if ( !on_leave ) { on_leave = true; on_enter = false; if ( !is_undefined(data[$ "on_leave"]) && data[$ "on_leave"] != -1 ) { data[$ "on_leave"](); } } } //Mouse Leave Function
		}
	}
}

///@desc Manages state for UI tabs.
function ui_manage() {
	live_auto_call 

	switch ( ui_tab ) {
		case 0: { //Dialogue
			#region Update Text
				var update_text = function() { //Update text function
					undo_stack_begin_move(); 
						with ( obj_system ) {
							var txt = new TextChange(textinput.GetValue(), textinput.GetCaret());
							undo_stack_apply_change(txt); 
						}
					undo_stack_complete_move();
					
					if ( !bord_visible ) { sfx_play(snd_enc1, 0, , 1.3); bord_visible = true; }
				}
				
				if ( textinput.IsFocused() ) { //If the input box is in focus
					var upd_ = false, keycur = keyboard_key;
					if ( keyboard_check(vk_anykey) && keycur != 0 ) { 
						switch ( keycur ) { //Banned keys
							case vk_shift: case vk_control: case vk_lcontrol: case vk_rcontrol: case 20: case vk_alt: case vk_lalt: case vk_ralt:
							case vk_up: case vk_down: case vk_left: case vk_right: case vk_escape: case vk_pageup: case vk_pagedown: { upd_ = false; } break;
							default: { upd_ = true; }
						}
						if ( upd_ ) { dial_updatet = dial_updatet_max; } //Start timer
					}
					
					if ( keyboard_check_pressed(vk_anykey) ) { //Typing sounds
						if ( upd_ ) { sfx_play(snd_txttype, , , random_range(0.8, 1.2)); } //Play typing sounds for unbanned keys
						else {
							switch ( keycur ) { //Play unique sounds
								case vk_shift: case 20: { sfx_play(snd_equip); } break;
								case vk_control: case vk_lcontrol: case vk_rcontrol: { sfx_play(snd_enc1); } break;
								case vk_up: case vk_down: case vk_left: case vk_right: { sfx_play(snd_txttype, , , 1.5); } break;
							}
						}
					}
					if ( keyboard_check(vk_control) && keyboard_check_pressed(ord("Z")) ) { //Undo/ redo
						if ( !keyboard_check(vk_shift) ) { undo_stack_undo(); } else { undo_stack_redo(); } 
					}
					if ( keyboard_check(vk_control) && keyboard_check_pressed(ord("S")) ) { soupy_context_clear(); } //Clear All
					if ( keyboard_check(vk_control) && keyboard_check_pressed(ord("D")) ) { soupy_context_page(); } //Insert Page Break
				}
			#endregion

			#region Switch between pages
				if ( UI_MESSAGE ) {
					#region Left Page
						if ( dial_text_page_c > 1 && dial_text_page > 0 ) { 
							if ( variable_instance_get(obj_system, "within_hover4") == undefined ) { variable_instance_set(obj_system, "within_hover4", false); }
							if ( variable_instance_get(obj_system, "yscale_4") == undefined ) { variable_instance_set(obj_system, "yscale_4", 1); }
		
							var x_ = 10, y_ = 400, within_ = range_within(mouse_x_gui, x_ - 20, x_ + 20) && range_within(mouse_y_gui, y_ - 30, y_ + 5);
							if ( within_ ) {
								if ( !within_hover4 ) { within_hover4 = true; sfx_play(snd_sel_switch); } //Hover
								if ( mouse_pressed ) { if ( !bord_visible ) { sfx_play(snd_enc1, 0, , 1.3); bord_visible = true; } sfx_play(snd_bump, , 0.7, 1.5); sfx_play(snd_throw); dial_text_page = approach(dial_text_page, 0, 1); yscale_4 = 0.5; } //Pressed
								if ( mouse_pressed_right ) { if ( !bord_visible ) { sfx_play(snd_enc1, 0, , 1.3); bord_visible = true; } sfx_play(snd_bump, , 0.7, 1.5); sfx_play(snd_throw, , , 1.3); dial_text_page = 0; } //Pressed Right
							}
							else { within_hover4 = false; }
							soupyclipm_begin_clip();
								draw_sprite_stretched_ext(spr_pixel, 0, ( x_ - 22 ) + 13, y_ - 17, 39, 34, c_white, 1);
							soupyclipm_end_clip();
							
							soupyclipm_draw();
								draw_sprite_stretched_ext(spr_pixel, 0, x_ - 22, y_ - 17, 39, 34, c_black, 1); //Outline
								draw_sprite_stretched(spr_border_undertale, 0, x_ - 20, y_ - 15, 35, 30); //Border
								draw_sprite_ensure(spr_effects_icons, 12, x_ - abs(sin(current_time/250) ) * 4, y_, -1, yscale_4, 180, within_ ? c_white : c_yellow); //Right Arrow
							shader_reset();
							yscale_4 = lerp(yscale_4, 1, 0.15);
						}
					#endregion
					#region Right Page
						if ( dial_text_page_c > 1 && dial_text_page < ( dial_text_page_c - 1 ) ) {
							if ( variable_instance_get(obj_system, "within_hover5") == undefined ) { variable_instance_set(obj_system, "within_hover5", false); }
							if ( variable_instance_get(obj_system, "yscale_5") == undefined ) { variable_instance_set(obj_system, "yscale_5", 1); }
		
							var x_ = 630, y_ = 400, within_ = range_within(mouse_x_gui, x_ - 20, x_ + 20) && range_within(mouse_y_gui, y_ - 30, y_ + 5);
							if ( within_ ) {
								if ( !within_hover5 ) { within_hover5 = true; sfx_play(snd_sel_switch); } //Hover
								if ( mouse_pressed ) { if ( !bord_visible ) { sfx_play(snd_enc1, 0, , 1.3); bord_visible = true; } sfx_play(snd_bump, , 0.7, 1.5); sfx_play(snd_throw); dial_text_page = approach(dial_text_page, dial_text_page_c, 1); yscale_5 = 0.5; } //Pressed
								if ( mouse_pressed_right ) { if ( !bord_visible ) { sfx_play(snd_enc1, 0, , 1.3); bord_visible = true; } sfx_play(snd_bump, , 0.7, 1.5); sfx_play(snd_throw, , , 1.3); dial_text_page = dial_text_page_c - 1; } //Pressed Right
							}
							else { within_hover5 = false; }
							soupyclipm_begin_clip();
								draw_sprite_stretched_ext(spr_pixel, 0, x_ - 15, y_ - 17, 24, 34, c_white, 1);
							soupyclipm_end_clip();
							
							soupyclipm_draw();	
								draw_sprite_stretched_ext(spr_pixel, 0, x_ - 15, y_ - 17, 39, 34, c_black, 1); //Outline
								draw_sprite_stretched(spr_border_undertale, 0, x_ - 13, y_ - 15, 35, 30); //Border
								draw_sprite_ensure(spr_effects_icons, 12, x_ + abs(sin(current_time/250) ) * 4, y_, , yscale_5, 180, within_ ? c_white : c_yellow); //Right Arrow
							shader_reset();
							yscale_5= lerp(yscale_5, 1, 0.15);
						}
					#endregion
					#region Page Indicator Text
						if ( dial_text_page_c > 1 && bord_visible ) {
							var pageind = scribble($"[offset,0,3]< Page {dial_text_page + 1}/ {dial_text_page_c} >[offsetPop] [spr_effects_icons,16]")
													.starting_format("fnt_abaddon", c_gray)
													.align(fa_center, fa_middle)
													.draw(320, 333)
						}
					#endregion
				}
			#endregion
			
			#region Textbox and Quick Text
				var x_ = 30, y_ = 130, w_ = 580, h_ = !bord_visible ? 310 : 160;
				draw_sprite_ensure(spr_pixel, 0, x_ - 10, y_ - 14, w_ + 20, h_ + 24, 0, c_black, 1); //Textbox Outline Outer
				draw_sprite_ensure(spr_pixel, 0, x_ - 8, y_ - 12, w_ + 16, h_ + 20, 0, c_white, 1); //Textbox Outline Inner
				draw_sprite_ensure(spr_pixel, 0, x_ - 2, y_ - 6, w_ + 4, h_ + 8, 0, c_black, 1); //Textbox Inner Shadow and Outline

				textinput.SetReadOnly(!UI_MESSAGE);
				if ( textinput.GetReadOnly() ) { textinput.SetEnabled(false); } else { textinput.SetEnabled(true); }
				textinput.Draw(x_, y_, w_, h_);
				QuillDrawOverlays();
		
				draw_format("left", "center", fnt_abaddon);
				draw_text_ext(20, 90, "Quick Colors:\n \nQuick Effects:", 12, -1);
			#endregion
			
			#region Color and Effects Function
				if ( variable_instance_get(obj_system, "butt_func") == undefined ) { variable_instance_set(obj_system, "butt_func", method({textinput, update_text, typist_spd}, function (data_, color_ = false) { //Button data
					#region Commands with extra parameters
						var extra_;
						switch ( data_ ) {
							case "scale": case "wait": case "alpha": { extra_ = ",0.5"; } break;
							case "cycle": { extra_ = ",0,120"; } break;
							case "offset": { extra_ = ",24,24"; } break;
							case "speed": { extra_ = $",{typist_spd}"; } break;
							default: { extra_ = ""; }
						}
					#endregion
					
					textinput.Focus();

					var txt_ = textinput.GetValue(), txt_insert = $"[{data_}{extra_}]", txt_insert_end = color_ ? "[/c]" : $"[/{data_}]", result;
					var getpos_ = textinput.GetSelection() ,pos_ = getpos_.start + 1, pos_2 = getpos_._end + 1; //Get the current cursor's position and highlighted position
					if ( !getpos_.has_selection ) { //Not trying to highlight anything
						result = string_insert(txt_insert, txt_, pos_);
					}
					else { //Between highlighted text
						result = string_insert(txt_insert, string_insert(txt_insert_end, txt_, pos_2), pos_);
					}
					textinput.SetValue(result); textinput.SetCaret(pos_ - 1); update_text();
					sfx_play(snd_bump, , , 1.5); audio_stop_sound(snd_updated);
				})); }
			#endregion

			#region Color Buttons
				if ( variable_instance_get(obj_system, "colors_get") == undefined ) { variable_instance_set(obj_system, "colors_get", __scribble_config_colours()); }
				draw_sprite_ext(spr_pixel, 0, 158 - 2, 68 - 2, 429 + 4, 14 + 4, 0, c_white, 1); //Palette Outline White
				draw_sprite_ext(spr_pixel, 0, 158, 68, 429, 14, 0, rgb(39, 31, 54), 1); //Palette Back
				var colors_ = ["c_red", "c_yellow", "c_blue", "c_lime", "c_aqua", "c_cyan", "c_purple", "c_orange", "c_maroon", "c_fuchsia", "c_gold", "c_white", "c_ltgray", "c_gray", "c_dkgray", "c_black"], colors_i = 0, colors_len = array_length(colors_); //Available colors
				repeat ( colors_len ) {
					var colors_cur = colors_[colors_i]; //Current color
					var butt_data = { x: 160 + ( 27 * colors_i ), y: 70, sprite: spr_color_button, draw_nine: false, leeway: 3, color_butt: colors_get[$ colors_cur], color_butt_hover: merge_color(colors_get[$ colors_cur], color_get_value(colors_get[$ colors_cur]) > 150 ? c_black : c_white, 0.3), on_click: method({ colors_cur }, function () { SYSTEMUI.butt_func(colors_cur, true); }), on_click_right: method({ colors_cur }, function () { 
						sfx_play(snd_equip2, , , 1.5); 
						var clrget = SYSTEMUI.colors_get[$ colors_cur];
						SYSTEMUI.dial_text_outline = SYSTEMUI.dial_text_outline != clrget ? clrget : c_black; //Switching to a new color? Change the text outline, otherwise disable text outline
					}) };
					
					butt_data[$ "x2"] = butt_data.x + sprite_get_width(butt_data.sprite); butt_data[$ "y2"] = butt_data.y + sprite_get_height(butt_data.sprite); 
					var butt_ = new Button(butt_data); butt_.update(); //Create button
				colors_i++; }
			#endregion
			
			#region Effects Buttons
				var effects_ = ["Wave   ", "Wheel    ", "Shake ", "Wobble  ", "Pulse ", "Rainbow", "Slant ", "Scale    ", "Cycle  ", "Blink    ", "Alpha  ", "Speed    "], effects_i = 0, effects_len = array_length(effects_), effects_off = effects_len - 6; //Available effects
				repeat ( effects_len ) {
					if ( effects_i > 5 ) { continue; }
					var effects_true = effects_i + ui_effoff;
					var effects_cur = effects_[effects_true]; //Current effect
					var butt_data = { x: 180 + ( 75 * effects_i ), y: 95, color_butt: c_orange, color_butt_hover: c_yellow, color: c_black, text: $"{effects_cur} [spr_effects_icons,{effects_true}]", padd_multi: 4, on_hover: undefined, on_click: method({ effects_cur }, function () { SYSTEMUI.butt_func(string_letters(string_lower(effects_cur))); }) } 
					var butt_ = new Button(butt_data); butt_.update(); //Create button
				effects_i++; }
				
				if ( UI_MESSAGE ) {
					#region Right Button
						if ( variable_instance_get(obj_system, "within_hover") == undefined ) { variable_instance_set(obj_system, "within_hover", false); }
						if ( variable_instance_get(obj_system, "yscale_") == undefined ) { variable_instance_set(obj_system, "yscale_", 1); }
						if ( ui_effoff < effects_off ) {
							var x_ = 605, y_ = 98, within_ = range_within(mouse_x_gui, x_ - 5, x_ + 20) && range_within(mouse_y_gui, y_ - 5, y_ + 5);
							if ( within_ ) {
								if ( !within_hover ) { within_hover = true; sfx_play(snd_sel_switch); } //Hover
								if ( mouse_pressed ) { sfx_play(snd_sel_switch, 0, , 1.3); ui_effoff = approach(ui_effoff, effects_off, 1); yscale_ = 0.5; } //Pressed
								if ( mouse_pressed_right ) { sfx_play(snd_throw, 0, , 1.3); sfx_play(snd_bump, , 0.7, 1.5); ui_effoff = effects_off; } //Pressed Right
							}
							else { within_hover = false; }
							draw_sprite_ensure(spr_effects_icons, 12, x_ + ( abs(sin(current_time/300) * 5) ) , y_, -1, yscale_, , within_ ? c_white : c_yellow); //Right Arrow
						}
						yscale_ = lerp(yscale_, 1, 0.15);
					#endregion
					#region Left Button
						if ( variable_instance_get(obj_system, "within_hover2") == undefined ) { variable_instance_set(obj_system, "within_hover2", false); }
						if ( variable_instance_get(obj_system, "yscale_2") == undefined ) { variable_instance_set(obj_system, "yscale_2", 1); }
						if ( ui_effoff > 0 ) {
							var x_ = 130, y_ = 98, within_ = range_within(mouse_x_gui, x_ - 20, x_ + 5) && range_within(mouse_y_gui, y_ - 5, y_ + 5);
							if ( within_ ) {
								if ( !within_hover2 ) {within_hover2 = true; sfx_play(snd_sel_switch); } //Hover
								if ( mouse_pressed ) { sfx_play(snd_sel_switch, 0, , 0.7); ui_effoff = approach(ui_effoff, 0, 1); yscale_2 = 0.5; } //Pressed
								if ( mouse_pressed_right ) { sfx_play(snd_throw, 0, , 1.3); sfx_play(snd_bump, , 0.7, 1.5); ui_effoff = 0; } //Pressed Right
							}
							else { within_hover2 = false; }
							draw_sprite_ensure(spr_effects_icons, 12, x_ - ( abs(sin(current_time/300) * 5) ), y_, , yscale_2, , within_ ? c_white : c_yellow); //Left Arrow
						}
						yscale_2 = lerp(yscale_2, 1, 0.15);
					#endregion
				}
			#endregion

			#region Text Update
				if ( dial_updatet > 1 && !textinput.ContextMenuIsOpened() ) { //Notification for updating text
					dial_updatet--;
					var ringcalc = map_value(dial_updatet, 0, dial_updatet_max, 0, 360), textx = 300, texty = 395; //Turn the values of a timer into a range of degrees
					
					var ninesl_ = sprite_get_nineslice(spr_bord), off_ = spr_bord == spr_border_deltarune ? 15 : 5; 
					if ( ninesl_.enabled ) { draw_sprite_stretched_ext(spr_bord, bord_index, ( textx - 110 ) - off_, ( texty - 20 ) - off_, 250 + ( off_ * 2 ), 40 + ( off_ * 2 ), bord_clr, 1); } else { draw_9slice(spr_bord, bord_index, textx - 110, texty - 20, 250, 40, bord_clr, bord_scale, bord_stretch); } //Dialogue Box
					var updatering = CleanRing(textx + 115, texty, 5, 10, 360, ringcalc) //Update text ring
														.Blend(c_yellow, 1)
														.Draw();
													
					draw_format(fa_center, fa_middle, fnt_speech, c_yellow);
					draw_text(textx, texty, "Live-updating text...!");
					
					if ( mouse_pressed && ( range_within(mouse_x_gui, ( textx - 110 ) - 20, ( ( textx - 110 ) + 250 ) + 20) && range_within(mouse_y_gui, ( texty - 20 ) - 20, ( (texty - 20 ) + 40 ) + 20) ) ) { dial_updatet = 1; } //Early regeneration
				}
				else { if ( dial_updatet == 1 ) { dial_updatet = 0; update_text(); } } //Update the text
			#endregion
			
			#region Change Cursor
				if ( UI_MESSAGE ) {
					if ( range_within(mouse_x_gui, 120, 620) && range_within(mouse_y_gui, 60, 120) ) { window_set_cursor(cr_drag); } //At the command palette
					else if ( range_within(mouse_x_gui, 20, 620) && range_within(mouse_y_gui, 110, 300) ) { window_set_cursor(cr_beam); } //At the textbox
					else { if ( mouse_y_gui >= 60 ) { window_set_cursor(cr_default); } }
				}
			#endregion
			
			#region Clear Page Face
				var resettime = 60;
				if ( bord_visible && FACE_CURRENT != -1 && ( range_within(mouse_x_gui, 40, 174) && range_within(mouse_y_gui, 323, 480) ) && mouse_check_right ) { //Hovering over the dialogue portrait
					soupy_alarm("removeface", resettime);
					soupy_alarm_run("removeface", 1, function () { FACE_CURRENT = -1; FACE_ORIGINAL = -1; FACE_PREVIOUS = -1; sfx_play(snd_hurtpowerful); }); //Timer to clear face

					draw_sprite_stretched_ext(spr_border_undertale, 0, 40, 323, 134, 136, c_red, 0.7); //BG
					var ringcalc = map_value(soupy_alarm_get("removeface", "timer", false), 0, resettime, 0, 360), textx = 110, texty = 390; //Turn the values of a timer into a range of degrees
					var updatering = CleanRing(textx, texty, 20, 30, 360, ringcalc) //Update text ring
														.Blend(c_red, 1)
														.Draw();
					draw_format(fa_center, fa_middle, fnt_speech, c_red);
					draw_text(textx, texty, "Clearing\n\n\n\n\n\nface...");
				}
				else { soupy_alarm_set("removeface", "timer", resettime); }
			#endregion
			
			#region Toggle Dialogue Box Visibility
				if ( UI_MESSAGE ) {
					if ( variable_instance_get(obj_system, "within_hover3") == undefined ) { variable_instance_set(obj_system, "within_hover3", false); }
					if ( variable_instance_get(obj_system, "yscale_3") == undefined ) { variable_instance_set(obj_system, "yscale_3", 1); }
		
					var x_ = 320, y_ = 473, within_ = range_within(mouse_x_gui, x_ - 20, x_ + 20) && range_within(mouse_y_gui, y_ - 30, y_ + 5);
					if ( within_ ) {
						if ( !within_hover3 ) { within_hover3 = true; sfx_play(snd_sel_switch); } //Hover
						if ( mouse_pressed ) {  sfx_play(snd_enc1, 0, , bord_visible ? 0.7 : 1.3); bord_visible = !bord_visible; yscale_3 = 0.5; } //Pressed
					}
					else { within_hover3 = false; }
					draw_sprite_ensure(spr_effects_icons, 12, x_, y_, , yscale_3, bord_visible ? 90 : 270, within_ ? c_white : c_yellow); //Left Arrow
					yscale_3 = lerp(yscale_3, 1, 0.15);
				}
			#endregion
			
			#region Create Mini Face
				if ( UI_MESSAGE ) {
					var xx_ = 632, yy_ = 470, within_ = range_within(mouse_x_gui, xx_ - 40, xx_ + 20) && range_within(mouse_y_gui, yy_ - 40, yy_ + 20);
					if ( variable_instance_get(obj_system, "within_mini") == undefined ) { variable_instance_set(obj_system, "within_mini", false); }
					if ( variable_instance_get(obj_system, "within_mini_off") == undefined ) { variable_instance_set(obj_system, "within_mini_off", false); }
					if ( within_ ) {
						if ( !within_mini ) { within_mini = true; sfx_play(snd_sel_switch); } //Hover
						if ( mouse_pressed ) { //Pressed
							sfx_play(snd_select);
							soup_store("minisprite", -1); soup_store("miniindex", 0); soup_store("minitext", "Text"); soup_store("minianim", false); soup_store("minifont", "fnt_determination");
							var miniarr = [
								new LuiText({ value: "Create a mini speech bubble!", text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }),
								new LuiRow().setFlexGrow(1).centerContent().addContent([
									new LuiText({ value: "Sprite:", width: 100, text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }),
									new LuiButton({ text: "Choose...", height: 40, width: 100, }).addEvent(LUI_EV_CLICK, function(element_) { external_choose_face(true, , false, , false, false); }),
									new LuiInput({ value: soup_checkout("minisprite", false), height: 40, placeholder: "spr_face_test", offset: 12, type_sfx: snd_txttype, color_normal: c_white, color_hover: c_gray, }).bindVariable(global.soupstore, "minisprite").addEvent(LUI_EV_CREATE, function(e_) { soup_store("datainput", e_); }).addEvent(LUI_EV_VALUE_UPDATE, function(e_) { 
										var spr_ = soup_checkout("dataimage", false), getface = get_face(e_.get()); 
										spr_.set(getface == -1 ? spr_gui_icons : getface); spr_.subimg = ( getface == -1 ? 3 : 0 );
									}),
									new LuiImage({ value: spr_gui_icons, subimg: 3, draw_normal: true, }).setSize(70, 70).addEvent(LUI_EV_CREATE, function(e_) { soup_store("dataimage", e_); }),
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
								new LuiRow().setPosX(90).addContent([
									new LuiText({ value: "Smooth Animation:", text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }),
									new LuiToggleSwitch({ value: soup_checkout("minianim", false), checkbox_spr: spr_gui_icons, checkbox_spr_index: 6, checkbox_clr: c_white, sound_click: snd_bump, sound_click_pitch: 1.3, ease: global.Ease.OutBack, }).bindVariable(global.soupstore, "minianim"),
								]),
								new LuiText({ value: "Left Click - Move mini | Right Click (Held) - Delete mini", color: c_gray, text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }),
								new LuiText({ value: "Note: Mini speeches only show up on the current highlighted page\nand within the dialogue box.", color: c_gray, text_halign: fa_center, text_valign: fa_middle, }),
								new LuiText({ value: "You can drag a face sprite on here too, btw! New sprites are\nimmediately added.", color: c_gray, text_halign: fa_center, text_valign: fa_middle, }),
								new LuiButton({ text: "Let's get soupy!!", height: 35, }).addEvent(LUI_EV_CLICK, function(element_) {
									var txt_ = soup_checkout("minitext", false), spr_ = get_face(soup_checkout("minisprite", false)), index_ = soup_checkout("miniindex", false), font_ = soup_checkout("minifont", false);
									if ( string_lettersdigits(txt_) == "" ) { SYSTEMUI.ui_paused = false; soupy_message("You haven't even written any|dialogue yet!!", "Go Back", 300, , , snd_error, , , true); exit; }
									if ( spr_ == -1 ) { SYSTEMUI.ui_paused = false; soupy_message("Make sure your face sprite|is a valid sprite.", "Go Back", 300, , , snd_error, , , true); exit; }
									if ( string_lettersdigits(font_) == "" ) { font_ = "fnt_determination"; }
									
									var struct_ = { text: txt_, face: spr_, index: index_ == "" ? 0 : real(index_), alpha: 1, font: font_, smooth: soup_checkout("minianim", false), page: SYSTEMUI.dial_text_page, };
									instance_create_depth(random_range(30, 310), random_range(310, 470), -1, obj_mini, struct_);
									var maincan = soup_checkout("datamain", false);
									soup_store_clear(); SYSTEMUI.ui_paused = false; maincan.destroy();
								}),
							];
							var maincan = soupy_popup(miniarr, function() { soup_store_clear(); SYSTEMUI.ui_paused = false; }, "Nevermind", , , , snd_select, , , 2);
							soup_store("datamain", maincan);
						}
					}
					else { within_mini = false; }
					within_mini_off = lerp(within_mini_off, within_ ? 15 : 0, 0.30);

					#region Sprites
						soupyclipm_begin_clip();
							draw_set_color(c_white); draw_rectangle(590, 430, 639, 479, false);
						soupyclipm_end_clip();

						soupyclipm_draw();
							draw_sprite_stretched_ext(spr_border_undertale_outlined, 0, ( xx_ - 17 ) - within_mini_off, ( yy_ - 17 ) - within_mini_off, 50, 50, within_ ? c_yellow : c_white, 1);
							draw_sprite_ensure(spr_gui_icons, 7, ( xx_ - within_mini_off ) + ( within_ ? 8 : 0 ), ( yy_ - within_mini_off ) + ( within_ ? 8 : 0 ), within_ ? 2 : 1, within_ ? 2 : 1, , within_ ? c_yellow : c_white);
						shader_reset();
					#endregion
				}
			#endregion
		} break;
	}
}