#region Default functions for the menu buttons
	function on_enter_() { if ( obj_system.ui_tab != id_ ) { sfx_play(snd_sel_switch); TweenFire("~ocirc", "$15", "y>", "ystart+5"); text = $"[c_yellow][wheel]{text_static}"; color_butt = c_yellow; } }
	function on_leave_() { if ( obj_system.ui_tab != id_ ) { TweenFire("~ocirc", "$15", "y>", "ystart"); text = text_static; color_butt = c_orange; } }
	function on_click_() { if ( obj_system.ui_tab != id_ ) { sfx_play(snd_select); obj_system.ui_tab = id_; on_reset_(); } else { sfx_play(snd_bump, , , random_range(0.8, 1.2)); } }
	function on_reset_() { 
		var i = 0;
		repeat ( array_length(obj_system.butt) ) { with ( obj_system.butt[i].data ) { if ( obj_system.ui_tab != id_ ) { TweenFire("~ocirc", "$15", "y>", "ystart"); text = text_static; color_butt = c_orange; } else { TweenFire("~ocirc", "$15", "y>", "ystart+5"); text = $"[c_yellow][wheel]{text_static}"; color_butt = c_yellow; } } i++; }
	}
#endregion

#macro DIAL_GIF if ( !dial_text_gif ) { exit; } //Only run if GIFs are enabled

function TextChange(txt) : UndoableChange() constructor { //Handle undo/ redoing changes
	prev_txt = obj_system.dial_text;
	mytxt = txt;
	
	static apply = function() { with ( obj_system ) { dial_text = other.mytxt; soupGUI.TextboxSetText(textBox, dial_text); } sfx_play(snd_equip);  }

    static undo = function() { with ( obj_system ) { dial_text = other.prev_txt; soupGUI.TextboxSetText(textBox, dial_text); } sfx_play(snd_cancel); }
}

///@desc Create a GUI button. Accepts { x, y, text, padd_(x1, y1, x2, y2, multi), x2, y2, sprite, index, scale, font, color, color_butt, halign, and valign, and functions for on_enter(runs once), on_hover, on_leave(once), on_click(once), on_held, on_released(once) }
///@param {struct} datastruct_ Data struct for button functionality.
function Button(datastruct_ = undefined) constructor {
	data = datastruct_; button = undefined; on_enter = false; on_leave = false;
	if ( is_undefined(data[$ "text"]) ) { data[$ "text"] = ""; }
	data[$ "text_static"] = data.text;

	static update = function() {
		var paddmulti = data[$ "padd_multi"] ?? 0, hastext = data.text != "";
		if ( hastext ) {
		button = scribble(data.text)
						.align(data[$ "halign"] ?? fa_center, data[$ "valign"] ?? fa_middle)
						.starting_format(data[$ "font"] ?? "fnt_determination_nomono", data[$ "color"] ?? c_white)
						.scale(data[$ "scale"] ?? 1)
						.padding(data[$ "padd_x1"] ?? 0 + paddmulti, data[$ "padd_y1"] ?? 0 + paddmulti, data[$ "padd_x2"] ?? 0 + paddmulti, data[$ "padd_y2"] ?? 0 + paddmulti);
		}
			
		var x_ = data[$ "x"] ?? 0, y_ = data[$ "y"] ?? 0, x2_ = data[$ "x2"] ?? 0, y2_ = data[$ "y2"] ?? 0, bbox = hastext ? button.get_bbox(x_, y_) : ({ left: x_, top: y_, right: x2_, bottom: y2_, width: x2_ - x_, height: y2_ - y_ }), leeway = 5;
		draw_sprite_stretched_ext(data[$ "sprite"] ?? spr_pixel, data[$ "index"] ?? 0, bbox.left, bbox.top, bbox.width, bbox.height, data[$ "color_butt"] ?? c_white, 1); //Draw nine-slice sprite
		if ( hastext ) { button.draw(x_, y_); } //Draw Scribble text
			
		if ( ( range_within(mouse_x_gui, bbox.left - leeway, bbox.right + leeway) && range_within(mouse_y_gui, bbox.top - leeway, bbox.bottom + leeway) ) && window_has_focus() ) { //If the mouse has enter within the bounding box
			if ( !on_enter ) { on_enter = true; on_leave = false; if ( !is_undefined(data[$ "on_enter"]) ) { data[$ "on_enter"](); } } //Mouse Entered Function
			if ( !is_undefined(data[$ "on_hover"]) ) { data[$ "on_hover"](); } //Mouse Hovering Function
			if ( mouse_pressed ) { if ( !is_undefined(data[$ "on_click"]) ) { data[$ "on_click"](); exit; } } //Mouse Pressed Function
			if ( mouse_check ) { if ( !is_undefined(data[$ "on_held"]) ) { data[$ "on_held"](); } } //Mouse Held Function
			if ( mouse_released ) { if ( !is_undefined(data[$ "on_released"]) ) { data[$ "on_released"](); } } //Mouse Released Function
		}
		else { //If the mouse just left the bounding box
			if ( on_enter ) { if ( !on_leave ) { on_leave = true; on_enter = false; if ( !is_undefined(data[$ "on_leave"]) ) { data[$ "on_leave"](); } } } //Mouse Leave Function
		}
	}
}

function ui_manage() {
	live_auto_call 

	switch ( ui_tab ) {
		case 0: { //Dialogue
			#region Update Text
				var update_text = function() { //Update text function
					undo_stack_begin_move(); 
						var result = obj_system.soupGUI.TextboxGetText(obj_system.textBox);
						var txt = new TextChange(result); undo_stack_apply_change(txt); 
					undo_stack_complete_move();
				}
				
				if ( soupGUI.TextboxGetFocus(textBox) ) { //If the input box is in focus
					var keycur = keyboard_key, upd_ = true;
					if ( keyboard_check(vk_anykey) ) { 
						switch ( keycur ) {
							case vk_shift: case vk_control: case vk_lcontrol: case vk_rcontrol: case 20: case vk_tab: case vk_alt: case vk_lalt: case vk_ralt:
							case vk_up: case vk_down: case vk_left: case vk_right: case vk_escape: case vk_pageup: case vk_pagedown : { upd_ = false; } break;
						}
						
						if ( upd_ ) { dial_updatet = 45; }
					}
					if ( keyboard_check_pressed(vk_anykey) && upd_ ) { sfx_play(snd_txttype);  }
					
					if ( keyboard_check(vk_control) && keyboard_check_pressed(ord("Z")) ) { dial_updatet = 0; if ( !keyboard_check(vk_shift) ) { undo_stack_undo(); } else { undo_stack_redo(); } }
					var ud = ( keyboard_check_pressed(vk_down) - keyboard_check_pressed(vk_up) ), lr = ( keyboard_check_pressed(vk_right) - keyboard_check_pressed(vk_left) );
					if ( ud != 0 || lr != 0 ) { sfx_play(snd_txttype, , , 1.5); }
				}
			#endregion
							
			var off_ = 8, x_ = textbox_data.x - off_, y_ = textbox_data.y - off_, w_ = textbox_data.w + ( off_ * 2 ), h_ = textbox_data.h + ( off_ * 2 );
			draw_set_alpha(1);
			draw_sprite_stretched_ext(spr_border_undertale, 0, x_ - 6, y_ - 2, w_ + 4, h_ + 8, c_black, 1); //Textbox Outline
			draw_sprite_stretched(spr_border_undertale, 0, x_, y_ - 4, w_, h_ + 4); //Textbox Border
			soupGUI.Draw();
			
			draw_format("left", "center", fnt_speech);
			draw_text_ext(30, 90, "Quick Colors:\n \nQuick Effects:", 14, -1);
			soupGUI.Update();
			
			#region Color and Effects Function
				var butt_func = method({soupGUI, textBox, update_text}, function (data_) { //Button data
					sfx_play(snd_bump, , , 1.5);
					soupGUI.TextboxSetFocus(textBox, true);
					var txt_ = soupGUI.TextboxGetText(textBox), txt_insert = $"[{data_}]", txt_insert_end = "[/]"
					var pos_ = soupGUI.TextboxGetPoint(textBox) + 1, pos_2 = soupGUI.TextboxGetPointSecondary(textBox) + 1;
					if ( pos_2 == pos_ ) { //Not trying to highlight anything
						var result = string_insert(txt_insert, txt_, pos_), finalpos = ( pos_ + string_length(txt_insert) ) - 1;
						soupGUI.TextboxSetText(textBox, result);
						soupGUI.TextboxSetPoint(textBox, finalpos); soupGUI.TextboxSetPointSecondary(textBox, finalpos);
					}
					else { //Between highlighted text
						var ending_ = pos_ > pos_2, pos_start = ending_ ? pos_2 : pos_, pos_end = ending_ ? pos_ : pos_2;
						var result = string_insert(txt_insert_end, txt_, pos_end), finalpos = pos_start - 1;
						result = string_insert(txt_insert, result, pos_start);
						soupGUI.TextboxSetText(textBox, result);
						soupGUI.TextboxSetPoint(textBox, finalpos); soupGUI.TextboxSetPointSecondary(textBox, finalpos);
					}
					update_text();
				}) ;
			#endregion
			
			#region Color Buttons
				var colors_ = ["c_red", "c_yellow", "c_blue", "c_lime", "c_aqua", "c_cyan", "c_purple", "c_orange", "c_maroon", "c_fuchsia", "c_gold", "c_white", "c_ltgray", "c_gray", "c_dkgray", "c_black"], colors_get = __scribble_config_colours(), colors_i = 0, colors_len = array_length(colors_); //Available colors
				repeat ( colors_len ) {
					var colors_cur = colors_[colors_i]; //Current color
					var butt_data = { x: 170 + ( 27 * colors_i ), y: 70, sprite: spr_pixel, color_butt: colors_get[$ colors_cur], on_click: method({ butt_func, colors_cur }, function () { butt_func(colors_cur); }) } 
					butt_data[$ "x2"] = butt_data.x + 20; butt_data[$ "y2"] = butt_data.y + 10; 
				
					draw_sprite_stretched_ext(spr_border_undertale, 0, butt_data.x - 3, butt_data.y - 3, ( butt_data.x2 - butt_data.x ) + 6, ( butt_data.y2 - butt_data.y ) + 6, c_white, 1); //Button Outline 3
					draw_sprite_stretched_ext(spr_border_undertale, 0, butt_data.x - 2, butt_data.y - 2, ( butt_data.x2 - butt_data.x ) + 4, ( butt_data.y2 - butt_data.y ) + 4, c_black, 1); //Button Outline 2
					draw_sprite_stretched_ext(spr_border_undertale, 0, butt_data.x - 1, butt_data.y - 1, ( butt_data.x2 - butt_data.x ) + 2, ( butt_data.y2 - butt_data.y ) + 2, c_white, 1); //Button Outline
					var butt_ = new Button(butt_data); butt_.update(); //Create button
				colors_i++; }
			#endregion
			
			#region Effects Buttons
				var effects_ = ["Wave   ", "Wheel   ", "Shake ", "Wobble ", "Pulse", "Rainbow"], effects_i = 0, effects_len = array_length(effects_); //Available effects
				repeat ( effects_len ) {
					var effects_cur = effects_[effects_i]; //Current effect
					var butt_data = { x: 190 + ( 75 * effects_i ), y: 95, color_butt: c_orange, color: c_black, text: $"{effects_cur} [spr_effects_icons,{effects_i}]", padd_multi: 4, on_click: method({ butt_func, effects_cur }, function () { butt_func(string_trim(string_lower(effects_cur))); }) } 
					var butt_ = new Button(butt_data); butt_.update(); //Create button
				effects_i++; }
			#endregion
			
			#region Text Update 
				if ( dial_updatet > 1 ) { //Notification for updating text
					dial_updatet--; 
				
					var ringcalc = map_value(dial_updatet, 0, 30, 0, 360), textx = 320; //Turn the values of a timer into a range of degrees
					var updatering = CleanRing(textx + 90, 90, 5, 10, 360, ringcalc) //Update text ring
													.Blend(c_yellow, 1)
													.Draw();
													
					draw_format(fa_center, fa_middle, fnt_speech, c_yellow);
					draw_text(textx, 90, "Updating text...!");
				}
				else { if ( dial_updatet == 1 ) { dial_updatet = 0; update_text(); } } //Update the text
			#endregion
		} break;
		
		case 1: { //Style
			var txt_ = scribble($"Style Tab")
							.align(fa_center, fa_middle)
							.scale(3)
							.draw(320, 220);
		} break;
		
		case 2: { //Face
			var txt_ = scribble("Face Tab")
							.align(fa_center, fa_middle)
							.scale(3)
							.draw(320, 220);
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
}