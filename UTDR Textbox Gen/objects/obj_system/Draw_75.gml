///@desc Screenshot task
live_auto_call 
if ( screenshot || record.enabled ) { 
	var dltrn = spr_bord == spr_border_deltarune; //Check if our border is Deltarune
	var out_ = bord_out; //Whether to save with an outline
	var folder = "UTDR-SoupGen-Export", fname = $"UTDR_SoupGen_0-{current_month}.{current_day}.{current_year}-_{current_hour};{current_minute};{current_second}.{current_time}-", _is_microsoft = ( os_type == os_windows || os_type == os_xboxseriesxs || os_type == os_gdk ), _path_separator = _is_microsoft? "\\"  :  "/";
	var offset_ = dltrn ? 8 : 0, offset_w = dltrn ? 15 : 0, offset_h = dltrn ? 16 : 0, x_ = ( 32 - offset_ ) - 2, y_ = ( 315 - offset_ ) - 2, w_ = ( 578 + offset_w ) + 4, h_ = ( 152 + offset_w ) + 4; //Border coords

	var smallbox = bord_small ? 2 : 1;
	screenshot_surf = surface_create(640/ smallbox, 480/ smallbox);
	surface_set_target(screenshot_surf);
		draw_clear_alpha(c_lime, 1); //For borders that aren't perfect rectangles
		
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
		
		draw_surface_ext(out_surf, 0, 0, bord_small ? 0.5 : 1, bord_small ? 0.5 : 1, 0, c_white, 1); //Our gen result
	surface_reset_target();
	
	var finish_func = method({folder, _path_separator, fname, record, x_, y_, w_, h_, smallbox, screenshot_surf }, function(gif_ = true) { //Finished recording/ screenshotting
		var fpath = $"{folder}{_path_separator}{fname}_.{gif_ ? "gif" : "png"}", fpath_final = $"{program_directory}{_path_separator}{folder}{_path_separator}{fname}_.{gif_ ? "gif" : "png"}";
		if ( gif_ ) {
			gif_save(record.id_, fpath_final);
			fpath = fpath_final;
		}
		else {
			surface_save_part(screenshot_surf, fpath, x_/ smallbox, y_/ smallbox, w_/ smallbox, h_/ smallbox); //Save output temp
			surface_save_part(screenshot_surf, fpath_final, x_/ smallbox, y_/ smallbox, w_/ smallbox, h_/ smallbox); //Save output actual
		}
			
		var form = new FormData(); //Upload the result to Litterbox for 1hr (This is for the online folks. This is also why a second temp image is made)
		/*form.add_data("reqtype", "fileupload");
		form.add_data("time", "1h");
		form.add_file("fileToUpload", fpath);
		http("https://litterbox.catbox.moe/resources/internals/api.php", "POST", form, , function(http_status, result) { //Sucess!
			show_debug_message($"{http_status} {result}");
			clipboard_set_text(result);
		}, 
		function(http_status, result) { show_debug_message($"{http_status} {result}"); }); //Failed*/
		
		//form.add_data("key", "c0a42a79bdff0058d6ee96b6e83b4143"); //ImgBB Host
		//form.add_data("expiration", "1800");
		//form.add_file("image", fpath);
		//http("https://api.imgbb.com/1/upload", "POST", form, , function(http_status, result) {
		//	show_debug_message($"{http_status} {result}");
		//	var real_result = json_parse(result);
		//	clipboard_set_text(real_result.data.url);
		//}, 
		//function(http_status, result) { show_debug_message($"{http_status} {result}"); }); //Failed
		
		if ( !gif_ ) { file_delete(fpath); }
		show_debug_message($"{fname} saved at {fpath_final}!");
		sfx_play(snd_dumbvictory);
		surface_free(screenshot_surf);
		screenshot_surf = -1;
		record.frames = 0;
		record.framesmax = 0;
		record.enabled = false;
		obj_system.dial_text_gif = false;
		record.id_ = -1;
		obj_system.dial_wrap_count = 1;
		obj_system.spr_bord = obj_system.bord_prev;
		execute_shell_simple(fpath_final, , , 6); //Open the image in the PC's default photo viewer (Windows only)
		exit;
	});
	
	if ( screenshot ) { 
		screenshot = false;
		finish_func(false);
	}
	else if ( record.enabled ) {
		var record_func = method({ record, screenshot_surf, x_, y_, w_, h_, smallbox, typist }, function(init_ = false) { if ( init_ ) { record.id_ = gif_open(w_/ smallbox, h_/ smallbox); typist.reset(); } else { var debug = gif_add_surface(record.id_, screenshot_surf, 2, x_/ smallbox, y_/ smallbox); } });
		if ( record.type == 0 ) { //No typing animation
			if ( record.frames == 0 ) { record_func(true); record.frames++; } //Enable GIF recording
			else { 
				if ( record.frames < record.framesmax ) { record_func(); record.frames++; } //Add frames to the GIF until we reach our target time
				else { finish_func(); }
			}
		}
		else { //Typing animation
			if ( record.id_ == -1 ) { record_func(true); exit; } 
			
			var state_ = typist.get_state();
			if ( state_ < 1 || ( state_ >= 1 && record.frames < 60 ) ) { record_func(); } //If we're still typing, keep recording
			
			if ( state_ >= 1 ) { //If we stopped typing
				if ( record.frames < 60 ) { record.frames++; }
				else { finish_func(); }
			}
		}
	}
}