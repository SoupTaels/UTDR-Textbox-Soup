///@desc Screenshot task
//if ( live_call() ) { return live_result; } 
if ( screenshot || record.enabled ) { 
	var dltrn = spr_bord == spr_border_deltarune; //Check if our border is Deltarune
	var out_ = bord_out; //Whether to save with an outline
	var folder = "UTDR-SoupGen-Export", fname = $"UTDR_SoupGen_-{current_month}.{current_day}.{current_year}-_{current_hour};{current_minute};{current_second}.{current_time}-", _is_microsoft = ( os_type == os_windows || os_type == os_xboxseriesxs || os_type == os_gdk ), _path_separator = _is_microsoft? "\\"  :  "/";
	var offset_ = dltrn ? 8 : 0, offset_w = dltrn ? 15 : 0, offset_h = dltrn ? 16 : 0, x_ = ( 32 - offset_ ) - 2, y_ = ( 315 - offset_ ) - 2, w_ = ( 578 + offset_w ) + 4, h_ = ( 152 + offset_w ) + 4; //Border coords

	#region Draw Surface
		screenshot_surf = surface_create(640, 480);
		surface_set_target(screenshot_surf);
			if ( !record.enabled ) { draw_clear_alpha(c_black, 0); } else { draw_clear_alpha(c_lime, 1); }//For borders that aren't perfect rectangles
		
			#region Dialogue Box Outline
				var out_thick = 2, offset_ = dltrn ? 8 : 0, offset_w = dltrn ? 15 : 0, offset_h = dltrn ? 16 : 0, bordx = 32 - offset_, bordy = 315 - offset_, bordw = 578 + offset_w, bordh = 152 + offset_w; //Border coords
				gpu_set_fog(true, c_black, 0, 0); //Draw solid color of sprite
					draw_sprite_stretched_ext(spr_bord, 0, bordx - out_thick, bordy, bordw, bordh, c_white, 1); //Dialogue Box Left
					draw_sprite_stretched_ext(spr_bord, 0, bordx + out_thick, bordy, bordw, bordh, c_white, 1); //Dialogue Box Right
					draw_sprite_stretched_ext(spr_bord, 0, bordx, bordy - out_thick, bordw, bordh, c_white, 1); //Dialogue Box Up
					draw_sprite_stretched_ext(spr_bord, 0, bordx, bordy + out_thick, bordw, bordh, c_white, 1); //Dialogue Box Down
				
					draw_sprite_stretched_ext(spr_bord, 0, bordx - out_thick, bordy - out_thick, bordw, bordh, c_white, 1); //Dialogue Box Left
					draw_sprite_stretched_ext(spr_bord, 0, bordx - out_thick, bordy + out_thick, bordw, bordh, c_white, 1); //Dialogue Box Right
					draw_sprite_stretched_ext(spr_bord, 0, bordx + out_thick, bordy - out_thick, bordw, bordh, c_white, 1); //Dialogue Box Up
					draw_sprite_stretched_ext(spr_bord, 0, bordx + out_thick, bordy + out_thick, bordw, bordh, c_white, 1); //Dialogue Box Down
				gpu_set_fog(false, c_white, 0, 0); //Reset effect
			#endregion (Yes we have to draw it like this)
		
			draw_surface_ext(out_surf, 0, 0, 1, 1, 0, c_white, 1); //Our gen result
		surface_reset_target();
	#endregion
	
	#region Function for finishing recording
		var finish_func = method({folder, _path_separator, fname, record, x_, y_, w_, h_, screenshot_surf }, function(gif_ = true) { //Finished recording/ screenshotting
			var fpath_final = $"{executable_get_directory()}{folder}{_path_separator}{fname}_.{gif_ ? "gif" : "png"}";
			if ( gif_ ) { gif_save(record.id_, fpath_final); } //Save GIF
			else { //Save screenshot
				surface_save_part(screenshot_surf, fpath_final, x_, y_, w_, h_); //Save output actual
			}

			show_debug_message($"{fname} saved at {fpath_final}!");
			sfx_play(snd_dumbvictory);
			surface_free(screenshot_surf); screenshot_surf = -1;
			with ( record ) { frames = 0; framesmax = 0; enabled = false; id_ = -1; }
			with ( SYSTEMUI ) { dial_text_gif = false; dial_wrap_count = 1; spr_bord = bord_prev; dial_text_page = 0; }
			execute_shell_simple(fpath_final, , , 6); //Open the image in the PC's default photo viewer (Windows only)
			exit;
		});
	#endregion
	
	if ( screenshot ) { screenshot = false; finish_func(false); }
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
			if ( state_ < 1 || ( state_ >= 1 && record.frames < record.delay ) ) { record_func(); exit; } //If we're still typing, keep recording
			if ( state_ >= 1 ) { //If we stopped typing
				if ( record.frames < record.delay ) { record.frames++; exit; } //Delay before moving on
				else { if ( dial_text_page < dial_text_page_c - 1 ) { record.frames = 0; dial_text_page++; sfx_play(snd_equip); exit; } else { finish_func(); } } //Either go to the next page or stop recording
			}
		}
	}
}