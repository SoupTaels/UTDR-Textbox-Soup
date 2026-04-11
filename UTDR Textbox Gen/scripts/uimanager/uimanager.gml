#region Default functions for the menu buttons
	function on_enter_() { if ( obj_system.ui_tab != id_ ) { audio_play_sound(snd_sel_switch, 0, false); TweenFire("~ocirc", "$15", "y>", "ystart+5"); text = $"[c_yellow][wheel]{text_static}"; color_butt = c_yellow; } }
	function on_leave_() { if ( obj_system.ui_tab != id_ ) { TweenFire("~ocirc", "$15", "y>", "ystart"); text = text_static; color_butt = c_orange; } }
	function on_click_() { if ( obj_system.ui_tab != id_ ) { audio_play_sound(snd_select, 0, false); obj_system.ui_tab = id_; on_reset_(); } else { audio_play_sound(snd_bump, 0, false); } }
	function on_reset_() { 
		var i = 0;
		repeat ( array_length(obj_system.butt) ) { with ( obj_system.butt[i].data ) { if ( obj_system.ui_tab != id_ ) { TweenFire("~ocirc", "$15", "y>", "ystart"); text = text_static; color_butt = c_orange; } else { TweenFire("~ocirc", "$15", "y>", "ystart+5"); text = $"[c_yellow][wheel]{text_static}"; color_butt = c_yellow; } } i++; }
	}
#endregion

#region Add External Faces
	soupTex = new Collage("Externals"); //Create a texture page for these sprites
	soupTex.StartBatch();
		var result = [], folders_ = directory_get_contents("faces", result,,,,,,,, ".png"); //Folders to look through

		for ( var i = 0, count = array_length(folders_); i < count; i++; ) { //Loop through folders
				var folds_ = folders_[i]; //Get Folders
				//show_debug_message($"Folder: {folds_}");
				for ( var f_ = 0, count_ = array_length(result); f_ < count_; f_++; ) { //Loop through folders
					var files_ = result[f_], foldname_ = $"faces\\{folds_}\\"; //Get Files, Folder Name
					if ( string_search(files_, foldname_, true) ) {
						//show_debug_message(files_);
						var newname_ = string_replace_all(files_, foldname_, ""); //First, remove "Face/(folder name)/"
						var newname_ = string_replace_all(newname_, "spr_", ""), isstrip_ = string_search(newname_, "_strip"); //Then remove "spr_". Check if the string contains "_strip"
						var newname_ = string_letters(newname_); //Then remove anything that isn't the alphabet
						var newname_ = string_replace_all(newname_, isstrip_ ? "strippng" : "png", ""); //Then remove "strippng" or "png"
						var newname_ = string_replace_all(newname_, folds_, $"{folds_}_"); //Finally, add back the underscore. Finished! Now we can call for their sprites using this identifier, rather than having to search through an array.
						//show_debug_message(newname_);
						soupTex.AddFileStrip(files_, newname_, , , CollageOrigin.CENTER, CollageOrigin.CENTER);
					}
				}
		}
	soupTex.FinishBatch();
	soupTex = soupTex.ToStatic(true, true); //Send these sprites to one big texture page, rather than what GM does by default and sends every sprite, every frame, to separate texture pages(not great for performance)
#endregion

function ui_manage() {
	live_auto_call 

	switch ( ui_tab ) {
		case 0: { //Dialogue
			#region Update Text
				#region Sounds and Timer
					if ( inputbox.has_focus ) { //If the input box is in focus
						if ( keyboard_check_pressed(vk_anykey) ) { 
							var keycur = keyboard_key, snd_ = -1;
							switch ( keycur ) { 
								case vk_enter: { snd_ = snd_equip2; } break;
								case vk_shift: case vk_lcontrol: case vk_rcontrol: { snd_ = snd_enc1; } break;
								case vk_up: case vk_down: case vk_left: case vk_right: { snd_ = snd_txttype; } break;
								default: { snd_ = snd_txttype; dial_updatet = 31; } //We add a delay to updating the text so that it doesn't put too much of a strain on Scribble. It's doing the heavy lifting here!
							}
							audio_play_sound(snd_, 0, false);
						}
					}
				#endregion
			
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
					else { if ( dial_updatet == 1 ) { dial_updatet = 0; dial_text = inputbox.get_text(); } } //Update the text
				#endregion
			#endregion
							
			draw_format(, , fnt_speech);
			draw_text(30, 100, "Raw Text: (Type below!)");
			inputbox.draw(30, 120); //Input Box Text
			draw_sprite_stretched(spr_border_textbox, 0, inputbox.pad_atx - inputbox.style.padding.left * 2, inputbox.pad_aty - inputbox.style.padding.top * 2, inputbox.style.w + inputbox.style.padding.right * 2, inputbox.style.h + inputbox.style.padding.bottom * 2); //Inputbox Border
		} break;
		
		case 1: { //Border
			var txt_ = scribble("Style Tab")
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