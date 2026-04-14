#region Default functions for the menu buttons
	function on_enter_() { if ( obj_system.ui_tab != id_ ) { audio_play_sound(snd_sel_switch, 0, false); TweenFire("~ocirc", "$15", "y>", "ystart+5"); text = $"[c_yellow][wheel]{text_static}"; color_butt = c_yellow; } }
	function on_leave_() { if ( obj_system.ui_tab != id_ ) { TweenFire("~ocirc", "$15", "y>", "ystart"); text = text_static; color_butt = c_orange; } }
	function on_click_() { if ( obj_system.ui_tab != id_ ) { audio_play_sound(snd_select, 0, false); obj_system.ui_tab = id_; on_reset_(); } else { audio_play_sound(snd_bump, 0, false); } }
	function on_reset_() { 
		var i = 0;
		repeat ( array_length(obj_system.butt) ) { with ( obj_system.butt[i].data ) { if ( obj_system.ui_tab != id_ ) { TweenFire("~ocirc", "$15", "y>", "ystart"); text = text_static; color_butt = c_orange; } else { TweenFire("~ocirc", "$15", "y>", "ystart+5"); text = $"[c_yellow][wheel]{text_static}"; color_butt = c_yellow; } } i++; }
	}
#endregion

#macro DIAL_GIF if ( !dial_text_gif ) { exit; } //Only run if GIFs are enabled

///@desc Create a GUI button. Accepts { x, y, text, padd_(x1, y1, x2, y2, multi), sprite, index, scale, font, color, color_butt, halign, and valign, and functions for on_enter(runs once), on_hover, on_leave(once), on_click(once), on_held, on_released(once) }
///@param {struct} datastruct_ Data struct for button functionality.
function Button(datastruct_ = undefined) constructor {
	data = datastruct_; button = undefined; on_enter = false; on_leave = false;
	data[$ "text"] = undefined ? "Button Text" : data.text;
	data[$ "text_static"] = data.text;

	static update = function() {
		var paddmulti = data[$ "padd_multi"] ?? 0;
		button = scribble(data.text)
						.align(data[$ "halign"] ?? fa_center, data[$ "valign"] ?? fa_middle)
						.starting_format(data[$ "font"] ?? "fnt_determination", data[$ "color"] ?? c_white)
						.scale(data[$ "scale"] ?? 1)
						.padding(data[$ "padd_x1"] ?? 0 + paddmulti, data[$ "padd_y1"] ?? 0 + paddmulti, data[$ "padd_x2"] ?? 0 + paddmulti, data[$ "padd_y2"] ?? 0 + paddmulti);
			
		var x_ = data[$ "x"] ?? 0, y_ = data[$ "y"] ?? 0, bbox = button.get_bbox(x_, y_), leeway = 5;
		draw_sprite_stretched_ext(data[$ "sprite"] ?? spr_pixel, data[$ "index"] ?? 0, bbox.left, bbox.top, bbox.width, bbox.height, data[$ "color_butt"] ?? c_white, 1); //Draw nine-slice sprite
		button.draw(x_, y_); //Draw Scribble text
			
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
				#region Sounds and Timer
					if ( inputbox.has_focus ) { //If the input box is in focus
						var keycur = keyboard_key, upd_ = false;
						if ( keyboard_check_pressed(vk_anykey) ) { 
							var snd_ = -1;
							switch ( keycur ) { 
								case vk_enter: { snd_ = snd_equip2; } break;
								case vk_shift: case vk_lcontrol: case vk_rcontrol: { snd_ = snd_enc1; } break;
								case vk_up: case vk_down: case vk_left: case vk_right: { snd_ = snd_txttype; } break;
								default: { snd_ = snd_txttype; upd_ = true; } //We add a delay to updating the text so that it doesn't put too much of a strain on Scribble. It's doing the heavy lifting here!
							}
							audio_play_sound(snd_, 0, false);
						}
						if ( ( keyboard_check(vk_anykey) && upd_ ) || keyboard_check(vk_backspace) ) { dial_updatet = 31; }
					}
				#endregion
			if (keyboard_check(vk_control) && keyboard_check_pressed(ord("Z"))) {
				dial_updatet = 0;
				if ( !keyboard_check(vk_shift) ) { undo_stack_undo(); } else { undo_stack_redo(); }
			}
				#region Text Update 
					if ( dial_updatet > 1 ) { 
						dial_updatet--; 
				
						var ringcalc = map_value(dial_updatet, 0, 30, 0, 360), textx = 320; //Turn the values of a timer into a range of degrees
						var updatering = CleanRing(textx + 90, 90, 5, 10, 360, ringcalc) //Update text ring
														.Blend(c_yellow, 1)
														.Draw();
													
						draw_format(fa_center, fa_middle, fnt_speech, c_yellow);
						draw_text(textx, 90, "Updating text...!");
					}
					else { if ( dial_updatet == 1 ) { dial_updatet = 0; undo_stack_begin_move(); var txt = new TextChange(inputbox.get_text()); undo_stack_apply_change(txt); undo_stack_complete_move(); } } //Update the text
				#endregion
			#endregion
							
			draw_format(, , fnt_speech);
			draw_text(30, 100, "Raw Text: (Type below!)");
			inputbox.draw(30, 120); //Input Box Text
			//draw_sprite_ensure(get_face("undyne", "officerpissed"), 0, 320, 240);
			draw_sprite_stretched(spr_border_textbox, 0, inputbox.pad_atx - inputbox.style.padding.left * 2, inputbox.pad_aty - inputbox.style.padding.top * 2, inputbox.style.w + inputbox.style.padding.right * 2, inputbox.style.h + inputbox.style.padding.bottom * 2); //Inputbox Border
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