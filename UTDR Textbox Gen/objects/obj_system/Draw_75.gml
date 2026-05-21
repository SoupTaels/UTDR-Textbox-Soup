///@desc Screenshot task
//if ( live_call() ) { return live_result; } 
if ( screenshot || record.enabled ) { 
	var dltrn = spr_bord == spr_border_deltarune; //Check if our border is Deltarune
	var out_ = bord_out; //Whether to save with an outline
	var folder = "UTDR-SoupGen-Export", fname = $"UTDR_SoupGen_-{current_month}.{current_day}.{current_year}-_{current_hour}.{current_minute}.{current_second}.{current_time}-";
	var offset_ = dltrn ? 8 : 0, offset_w = dltrn ? 15 : 0, offset_h = dltrn ? 16 : 0, x_ = ( 32 - offset_ ) - ( out_ ? 2 : 0 ), y_ = ( 315 - offset_ ) - ( out_ ? 2 : 0 ), w_ = ( 578 + offset_w ) + ( out_ ? 4 : 0 ), h_ = ( 152 + offset_w ) + ( out_ ? 4 : 0 ); //Border coords
	
	#region Draw Surface
		screenshot_surf = surface_create(640, 480);
		surface_set_target(screenshot_surf);
			if ( !record.enabled ) { draw_clear_alpha(c_black, 0); } else { draw_clear_alpha(screenshot_back, 1); }//For borders that aren't perfect rectangles
		
			#region Dialogue Box Outline
				if ( out_ && bord_box_visible ) {
					var out_thick = 2, offset_ = dltrn ? 8 : 0, offset_w = dltrn ? 15 : 0, offset_h = dltrn ? 16 : 0, bordx = 32 - offset_, bordy = 315 - offset_, bordw = 578 + offset_w, bordh = 152 + offset_w; //Border coords
					gpu_set_fog(true, c_black, 0, 0); //Draw solid color of sprite
						draw_surface_ext(out_surf, -out_thick, 0, 1, 1, 0, c_white, 1); //Dialogue Box Left
						draw_surface_ext(out_surf, out_thick, 0, 1, 1, 0, c_white, 1); //Dialogue Box Right
						draw_surface_ext(out_surf, 0, -out_thick, 1, 1, 0, c_white, 1); //Dialogue Box Up
						draw_surface_ext(out_surf, 0, out_thick, 1, 1, 0, c_white, 1); //Dialogue Box Down
						
						draw_surface_ext(out_surf, -out_thick, -out_thick, 1, 1, 0, c_white, 1); //Dialogue Box Up Left
						draw_surface_ext(out_surf, out_thick, -out_thick, 1, 1, 0, c_white, 1); //Dialogue Box Up Right
						draw_surface_ext(out_surf, -out_thick, out_thick, 1, 1, 0, c_white, 1); //Dialogue Box Down Left
						draw_surface_ext(out_surf, out_thick, out_thick, 1, 1, 0, c_white, 1); //Dialogue Box Down Right
					gpu_set_fog(false, c_white, 0, 0); //Reset effect
				}
			#endregion (Yes we have to draw it like this)
			draw_surface_ext(out_surf, 0, 0, 1, 1, 0, c_white, 1); //Our gen result
			if ( instance_exists(obj_mini) ) { with ( obj_mini ) { draw(); } }
		surface_reset_target();
	#endregion
	
	#region Function for finishing recording
		var finish_func = method({folder, fname, record, x_, y_, w_, h_, screenshot_surf }, function(gif_ = true, stack_ = false, cancel_ = false) { //Finished recording/ screenshotting
			var fpath_final = $"{executable_get_directory()}{folder}{PATHSEP}{fname}_.{gif_ ? "gif" : "png"}";
			if ( !cancel_ ) { if ( !stack_ ) {
				if ( gif_ ) { record.id_ = gif_save(record.id_, fpath_final); } //Save GIF
				else { surface_save_part(screenshot_surf, fpath_final, x_, y_, w_, h_); } //Save screenshot
				
				soupy_message($"{fname}.{gif_ ? "gif" : "png"}[/] [rainbow][wave]saved at[/]| |[c_lime]{fpath_final}![/]| |Your [c_gold]good soup[/] is ready!|The file path was [c_yellow]copied to your clipboard[/] and|the result will open up in your [c_cyan]default image viewer[/].", "I'm so soupy!!", , , , snd_dumbvictory, fnt_abaddon, , , true, 590);
				execute_shell_simple($"{executable_get_directory()}{folder}", , , 6); //Open the directory (Windows only)
				execute_shell_simple(fpath_final, , , 6); //Open the image in the PC's default photo viewer (Windows only)
				clipboard_set_text(fpath_final);
			} }
			else { soup_checkout("export dialogue"); soupy_message("The export operation was canceled.", , 350, , , snd_cancel, , function(){ TweenScript(SYSTEMUI, 0, 2, function(){ soup_store_clear(); }); }); if ( record.enabled ) { record.id_ = gif_save(record.id_, $"{directory_get_temporary_path()}soupytemp.gif"); file_delete($"{directory_get_temporary_path()}soupytemp.gif"); } }
			
			surface_free(screenshot_surf); screenshot_surf = -1;
			with ( record ) { frames = 0; framesmax = 0; enabled = false; id_ = -1; }
			with ( SYSTEMUI ) { screenshot = false; screenshot_stacked = false; dial_text_gif = false; dial_wrap_count = 1; spr_bord = bord_prev; dial_text_page = 0; bord_box_visible = true; ui_tab = soup_checkout("tablast", , true); ui_visible = true; ui_reset(); }
			exit;
		});
	#endregion
	
	#region Cancel Early
		if ( soup_store_undefined("doublepress") ) { soup_store("doublepress", 0, , true); }
		if ( keyboard_check_pressed(vk_escape) ) {
			if ( soup_checkout("doublepress", false, true) < 1 ) { global.soupstore_global[$ "doublepress"]++; soupy_alarm_set("doublepress", "timer", 15); sfx_play(snd_bump); } else { if ( instance_exists(obj_stacker) ) { obj_stacker.abort = true; instance_destroy(obj_stacker); } finish_func(, , true); soup_store("doublepress", 0, , true); exit; }
		}
		soupy_alarm("doublepress", 15);
		soupy_alarm_run("doublepress", 0, function() { soup_store("doublepress", 0, , true); }); 
	#endregion
	
	if ( screenshot ) { 
		if ( !screenshot_stacked ) { screenshot = false; finish_func(false); }
		else {
			if ( dial_text_page < dial_text_page_c ) { //Create sprite from surface, then push them to the stack
				with ( obj_stacker ) {
					if ( soupstack_path == "" ) { var fpath_final = $"{executable_get_directory()}{folder}{PATHSEP}{fname}_.png"; soupstack_path = fpath_final; soupstack_fname = fname; soupstack_folder = folder; }
					array_push(soupstack_spr, sprite_create_from_surface(other.screenshot_surf, x_, y_, w_, h_, false, false, 0, 0));
				}
				dial_text_page++; sfx_play(snd_equip2); 
			}
			else { finish_func(false, true); screenshot = false; instance_destroy(obj_stacker); exit; }
		}
	}
	else if ( record.enabled ) {
		var record_func = method({ record, screenshot_surf, x_, y_, w_, h_, typist }, function(init_ = false) { if ( init_ ) { record.id_ = gif_open(w_, h_); typist.reset(); } else { var debug = gif_add_surface(record.id_, screenshot_surf, 2, x_, y_, record.quant); } });
		if ( record.type == 0 ) { //No typing animation
			if ( record.frames == 0 ) { record_func(true); record.frames++; sfx_play(snd_equip); exit; } //Enable GIF recording
			else { 
				if ( record.frames < record.framesmax ) { record_func(); record.frames++; exit; } else { finish_func(); exit; } //Add frames to the GIF until we reach our target time
			}
		}
		else { //Typing animation
			if ( record.id_ == -1 ) { record_func(true); exit; } //Initalize recording
			var state_ = typist.get_state();
			if ( state_ < 1 || ( state_ >= 1 && record.frames < record.delay ) ) { record_func(); } //If we're still typing, keep recording
			if ( state_ >= 1 ) { //If we stopped typing
				if ( record.frames < record.delay ) { record.frames++; exit; } //Delay before moving on
				else { if ( dial_text_page < dial_text_page_c - 1 ) { record.frames = 0; point_visible = false; dial_text_page++; sfx_play(snd_equip); exit; } else { finish_func(); } } //Either go to the next page or stop recording
			}
		}
	}
}