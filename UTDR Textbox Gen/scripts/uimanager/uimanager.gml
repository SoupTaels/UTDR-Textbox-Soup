#macro DIAL_GIF if ( !dial_text_gif ) { exit; } //Only run if GIFs are enabled
#macro UI_MESSAGE obj_system.ui_message.is_destroyed //Only function if there isn't a message box being displayed
#macro USING_FACE dial_face[dial_text_page] != -1 && dial_face[dial_text_page] != 0

#region Default functions for the menu buttons
	function on_enter_() { if ( obj_system.ui_tab != id_ ) { sfx_play(snd_sel_switch); TweenFire("~ocirc", "$15", "yoff>", 5); text = $"[c_yellow][wheel]{text_static}"; color_butt = c_yellow; } }
	function on_leave_() { if ( obj_system.ui_tab != id_ ) { TweenFire("~ocirc", "$15", "yoff>", 0); text = text_static; color_butt = c_orange; } window_set_cursor(cr_default); }
	function on_click_() { if ( obj_system.ui_tab != id_ ) { sfx_play(snd_select); obj_system.ui_tab = id_; on_reset_(); } else { sfx_play(snd_bump, , , random_range(0.8, 1.2)); } }
	function on_hover_() { window_set_cursor(cr_drag); }
	function on_reset_() { 
		obj_system.ui_reset();
		
		var i = 0;
		repeat ( array_length(obj_system.butt) ) { with ( obj_system.butt[i].data ) { if ( obj_system.ui_tab != id_ ) { TweenFire("~ocirc", "$15", "yoff>", 0); text = text_static; color_butt = c_orange; } else { TweenFire("~ocirc", "$15", "yoff>", 5); text = $"[c_yellow][wheel]{text_static}"; color_butt = c_yellow; } } i++; }
	}
#endregion

function TextChange(txt, point) : UndoableChange() constructor { //Handle undo/ redoing changes
	live_auto_call
	prev_txt = obj_system.dial_text; //Store previous/ inital text
	point_prev = obj_system.textinput.GetCaret(); //Get previous point
	mytxt = txt; //Get our new text
	point_ = point; //Get our new point

	static can_apply = function() { return ( obj_system.dial_text != mytxt ); } //Don't push the same unchanged text to the undo stack
	static apply = function() { with ( obj_system ) { dial_text = other.mytxt; textinput.SetValue(dial_text); textinput.SetCaret(other.point_); } sfx_play(snd_updated); } //Apply recent changes
    static undo = function() { with ( obj_system ) { dial_text = other.prev_txt; textinput.SetValue(dial_text); textinput.SetCaret(other.point_prev); } sfx_play(snd_throw); }
}

///@desc Create a GUI button. Accepts { x, y, text, padd_(x1, y1, x2, y2, multi), x2, y2, sprite, draw_nine, index, (x)(y)scale, angle, font, color, color_butt, halign, and valign, and functions for on_enter(runs once), on_hover, on_leave(once), on_click(once), on_held, on_released(once) }
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
			
		var spr_ = data[$ "sprite"] ?? spr_pixel, index = data[$ "index"] ?? 0, clrbutt = data[$ "color_butt"] ?? c_white, clrbutthovered = data[$ "color_butt_hover"] ?? data.color_butt, angle = data[$ "angle"] ?? 1, xscale = data[$ "xscale"] ?? 1, yscale = data[$ "yscale"] ?? 1, scalemulti = data[$ "scale"] ?? 1, x_ = data[$ "x"] ?? 0, y_ = data[$ "y"] ?? 0, x2_ = data[$ "x2"] ?? 0, y2_ = data[$ "y2"] ?? 0, xoff = data[$ "xoff"] ?? 0, yoff = data[$ "yoff"] ?? 0, bbox = hastext ? button.get_bbox(x_, y_) : ({ left: x_, top: y_, right: x2_, bottom: y2_, width: x2_ - x_, height: y2_ - y_ }), leeway = 5;
		var visible_ = data[$ "draw_nine"] ?? true;
		var hovered = range_within(mouse_x_gui, bbox.left - leeway, bbox.right + leeway) && range_within(mouse_y_gui, bbox.top - leeway, bbox.bottom + leeway);
		if ( visible_ ) { draw_sprite_stretched_ext(spr_, index, bbox.left + xoff, bbox.top + yoff, bbox.width, bbox.height, !hovered ? clrbutt : clrbutthovered, 1); } //Draw nine-slice sprite
		else { draw_sprite_ext(spr_, index, bbox.left + xoff, bbox.top + yoff, xscale * scalemulti, yscale * scalemulti, angle, !hovered ? clrbutt : clrbutthovered, 1); } //Draw normal sprite
		if ( hastext ) { button.draw(x_ + xoff, y_ + yoff); } //Draw Scribble text
			
		if ( hovered && window_has_focus() ) { //If the mouse has enter within the bounding box
			if ( UI_MESSAGE ) { 
				if ( !on_enter ) { on_enter = true; on_leave = false; if ( !is_undefined(data[$ "on_enter"]) ) { data[$ "on_enter"](); } } //Mouse Entered Function
				if ( !is_undefined(data[$ "on_hover"]) ) { data[$ "on_hover"](); } //Mouse Hovering Function
				if ( mouse_pressed ) { if ( !is_undefined(data[$ "on_click"]) ) { data[$ "on_click"](); exit; } } //Mouse Pressed Function
				if ( mouse_check ) { if ( !is_undefined(data[$ "on_held"]) ) { data[$ "on_held"](); } } //Mouse Held Function
				if ( mouse_released ) { if ( !is_undefined(data[$ "on_released"]) ) { data[$ "on_released"](); } } //Mouse Released Function
				if ( mouse_pressed_right ) { if ( !is_undefined(data[$ "on_click_right"]) ) { data[$ "on_click_right"](); exit; } } //Mouse Pressed Function
				if ( mouse_check_right ) { if ( !is_undefined(data[$ "on_held_right"]) ) { data[$ "on_held_right"](); } } //Mouse Held Function
				if ( mouse_released_right ) { if ( !is_undefined(data[$ "on_released_right"]) ) { data[$ "on_released_right"](); } } //Mouse Released Function
			}
		}
		else { //If the mouse just left the bounding box
			if ( on_enter ) { if ( !on_leave ) { on_leave = true; on_enter = false; if ( !is_undefined(data[$ "on_leave"]) ) { data[$ "on_leave"](); } } } //Mouse Leave Function
		}
	}
}

///@desc Display a LimeUI message box, blocking ui
function soupy_message(message_, snd_ = snd_error, height_ = 50, y_ = 10) { 
	sfx_play(snd_);
	if ( UI_MESSAGE ) { obj_system.ui_message = luiShowMessage(obj_system.soupy_lui, , , message_, , y_); obj_system.ui_message.setHeight(height_); }
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
					if ( keyboard_check(vk_control) ) { //Disable updating
						if ( keyboard_check(ord("Z")) || keyboard_check(ord("X")) || keyboard_check(ord("C")) || keyboard_check(ord("A")) ) { dial_updatet = 0; }
					}
				}
			#endregion

			#region Textbox and Quick Text
				var x_ = 30, y_ = 130, w_ = 580, h_ = !bord_visible ? 245 : 160;
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
				var butt_func = method({textinput, update_text, typist_spd}, function (data_, color_ = false) { //Button data
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
				});
			#endregion

			#region Color Buttons
				if ( variable_instance_get(obj_system, "colors_get") == undefined ) { variable_instance_set(obj_system, "colors_get", __scribble_config_colours()); }
				draw_sprite_ext(spr_pixel, 0, 158 - 2, 68 - 2, 429 + 4, 14 + 4, 0, c_white, 1); //Palette Outline White
				draw_sprite_ext(spr_pixel, 0, 158, 68, 429, 14, 0, rgb(39, 31, 54), 1); //Palette Back
				var colors_ = ["c_red", "c_yellow", "c_blue", "c_lime", "c_aqua", "c_cyan", "c_purple", "c_orange", "c_maroon", "c_fuchsia", "c_gold", "c_white", "c_ltgray", "c_gray", "c_dkgray", "c_black"], colors_i = 0, colors_len = array_length(colors_); //Available colors
				repeat ( colors_len ) {
					var colors_cur = colors_[colors_i]; //Current color
					var butt_data = { x: 160 + ( 27 * colors_i ), y: 70, sprite: spr_pixel, color_butt: colors_get[$ colors_cur], color_butt_hover: merge_color(colors_get[$ colors_cur], color_get_value(colors_get[$ colors_cur]) > 150 ? c_black : c_white, 0.3), on_click: method({ butt_func, colors_cur }, function () { butt_func(colors_cur, true); }), on_click_right: method({ butt_func, colors_cur }, function () { 
						sfx_play(snd_equip2, , , 1.5); 
						if ( obj_system.dial_text_outline != obj_system.colors_get[$ colors_cur] ) { obj_system.dial_text_outline = obj_system.colors_get[$ colors_cur]; } //Switching to a new color? Change the text outline
						else { obj_system.dial_text_outline = c_black; } //Disable text outline
					}) };

					butt_data[$ "x2"] = butt_data.x + 20; butt_data[$ "y2"] = butt_data.y + 10; 
					var butt_ = new Button(butt_data); butt_.update(); //Create button
				colors_i++; }
			#endregion
			
			#region Effects Buttons
				var effects_ = ["Wave   ", "Wheel    ", "Shake ", "Wobble  ", "Pulse ", "Rainbow", "Slant ", "Scale    ", "Cycle  ", "Blink    ", "Alpha  ", "Speed    "], effects_i = 0, effects_len = array_length(effects_), effects_off = effects_len - 6; //Available effects
				repeat ( effects_len ) {
					if ( effects_i > 5 ) { continue; }
					var effects_true = effects_i + ui_effoff;
					var effects_cur = effects_[effects_true]; //Current effect
					var butt_data = { x: 180 + ( 75 * effects_i ), y: 95, color_butt: c_orange, color_butt_hover: c_yellow, color: c_black, text: $"{effects_cur} [spr_effects_icons,{effects_true}]", padd_multi: 4, on_hover: undefined, on_click: method({ butt_func, effects_cur }, function () { butt_func(string_letters(string_lower(effects_cur))); }) } 
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
				if ( dial_updatet > 1 ) { //Notification for updating text
					dial_updatet--;
					var ringcalc = map_value(dial_updatet, 0, dial_updatet_max, 0, 360), textx = 300, texty = 395; //Turn the values of a timer into a range of degrees
					draw_sprite_stretched(spr_bord, 0, textx - 110, texty - 20, 250, 40);
					
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
		} break;
		
		case 1: { //Style
			var txt_ = scribble($"Style Tab")
							.align(fa_center, fa_middle)
							.scale(3)
							.draw(320, 220);
		} break;
		
		case 2: { //Face

		} break;
		
		case 3: { //Border
			var txt_ = scribble("Border Tab")
							.align(fa_center, fa_middle)
							.scale(3)
							.draw(320, 220);
							
			/*var bord_ = asset_get_index("border_custom_example");
			if ( bord_ != -1 ) { draw_nineslice(bord_, 230, 112, mouse_x_gui, mouse_y_gui); }*/
		} break;
		
		case 4: { //About
			scribble_anim_wheel(3, SCRIBBLE_DEFAULT_WHEEL_FREQUENCY, SCRIBBLE_DEFAULT_WHEEL_SPEED);
			var txt_ = scribble("[rainbow][wheel]So soupy!!")
							.align(fa_center, fa_middle)
							.scale(3)
							.draw(320, 220);
			scribble_anim_wheel(SCRIBBLE_DEFAULT_WHEEL_SIZE, SCRIBBLE_DEFAULT_WHEEL_FREQUENCY, SCRIBBLE_DEFAULT_WHEEL_SPEED);
		} break;
	}
	
	#region Toggle Dialogue Box Visibility
		if ( UI_MESSAGE && ui_tab == 0 ) {
			if ( variable_instance_get(obj_system, "within_hover3") == undefined ) { variable_instance_set(obj_system, "within_hover3", false); }
			if ( variable_instance_get(obj_system, "yscale_3") == undefined ) { variable_instance_set(obj_system, "yscale_3", 1); }
		
			var x_ = 320, y_ = 473, within_ = range_within(mouse_x_gui, x_ - 20, x_ + 20) && range_within(mouse_y_gui, y_ - 30, y_ + 5);
			if ( within_ ) {
				if ( !within_hover3 ) { within_hover3 = true; sfx_play(snd_sel_switch); } //Hover
				if ( mouse_pressed ) { sfx_play(snd_enc1, 0, , bord_visible ? 0.7 : 1.3); bord_visible = !bord_visible; yscale_3 = 0.5; } //Pressed
			}
			else { within_hover3 = false; }
			draw_sprite_ensure(spr_effects_icons, 12, x_, y_, , yscale_3, bord_visible ? 90 : 270, within_ ? c_white : c_yellow); //Left Arrow
			yscale_3 = lerp(yscale_3, 1, 0.15);
		}
	#endregion
	
	#region Switch Between Pages
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
					draw_sprite_stretched_ext(spr_pixel, 0, x_ - 22, y_ - 17, 39, 34, c_black, 1); //Outline
					draw_sprite_stretched(spr_border_undertale, 0, x_ - 20, y_ - 15, 35, 30); //Border
					draw_sprite_ensure(spr_effects_icons, 12, x_ - abs(sin(current_time/250) ) * 4, y_, -1, yscale_4, 180, within_ ? c_white : c_yellow); //Right Arrow
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
					draw_sprite_stretched_ext(spr_pixel, 0, x_ - 15, y_ - 17, 39, 34, c_black, 1); //Outline
					draw_sprite_stretched(spr_border_undertale, 0, x_ - 13, y_ - 15, 35, 30); //Border
					draw_sprite_ensure(spr_effects_icons, 12, x_ + abs(sin(current_time/250) ) * 4, y_, , yscale_5, 180, within_ ? c_white : c_yellow); //Right Arrow
					yscale_5= lerp(yscale_5, 1, 0.15);
				}
			#endregion
		}
		#region Page Indicator Text
			if ( dial_text_page_c > 1 && bord_visible ) {
				draw_format("center", "center", fnt_abaddon, , 0.4);
				draw_text(320, 333, $"< Page {dial_text_page + 1}/ {dial_text_page_c} >");
				draw_format();
			}
		#endregion
	#endregion
}