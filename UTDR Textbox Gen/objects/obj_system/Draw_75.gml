///@desc Screenshot task

if ( screenshot || record.enabled ) { 
	var dltrn = spr_bord == spr_border_deltarune; //Check if our border is Deltarune
	var out_ = bord_out; //Whether to save with an outline
	var folder = "UTDR-SoupGen-Export", fname = $"UTDR_SoupGen_-{current_month}.{current_day}.{current_year}-_{current_hour};{current_minute};{current_second}.{current_time}-", _is_microsoft = ( os_type == os_windows || os_type == os_xboxseriesxs || os_type == os_gdk ), _path_separator = _is_microsoft? "\\"  :  "/";
	var x_ = ( dltrn ? 24 : 32 ) - ( out_ ? 2 : 0 ), y_ = ( dltrn ? 312 : 320 ) - ( out_ ? 2 : 0 ), w_ = ( dltrn ? 593 : 578 ) + ( out_ ? 4 : 0 ), h_ = ( dltrn ? 167 : 152 ) + ( out_ ? 4 : 0 );

	var smallbox = bord_small ? 2 : 1;
	screenshot_surf = surface_create(640/ smallbox, 480/ smallbox);
	surface_set_target(screenshot_surf);
		draw_clear_alpha(c_black, 0);
		if ( bord_out ) { draw_sprite_ext(spr_pixel, 0, x_/ smallbox, y_/ smallbox, w_/ smallbox, h_/ smallbox, 0, c_black, 1); } //Our outline, if enabled
		draw_surface_ext(out_surf, 0, 0, bord_small ? 0.5 : 1, bord_small ? 0.5 : 1, 0, c_white, 1);
	surface_reset_target();
	
	if ( screenshot ) { 
		var fpath = $"{folder}{_path_separator}{fname}_.png", fpath_final = $"{program_directory}{_path_separator}{folder}{_path_separator}{fname}_.png"; //UTDR-SoupGen-Export/ UTDR_SoupGen_4.11.20267:01:36 PM.3233
	
		surface_save_part(screenshot_surf, fpath, x_/ smallbox, y_/ smallbox, w_/ smallbox, h_/ smallbox); //Save output temp
		surface_save_part(screenshot_surf, fpath_final, x_/ smallbox, y_/ smallbox, w_/ smallbox, h_/ smallbox); //Save output actual
		surface_free(screenshot_surf);
		screenshot_surf = -1;
	
		show_debug_message($"{fname} saved at {fpath_final}!");
		screenshot = false;
		execute_shell_simple(fpath_final, , , 6); //Open the image in the PC's default photo viewer (Windows only)
		audio_play_sound(snd_dumbvictory, 0, false);
		
		//var form = new FormData(); //Upload the result to Litterbox for 1hr (This is for the online folks. This is also why a second temp image is made)
		//form.add_data("reqtype", "fileupload");
		//form.add_data("time", "1h");
		//form.add_file("fileToUpload", fpath);
		//http("https://litterbox.catbox.moe/resources/internals/api.php", "POST", form, , function(http_status, result) {
		//	show_message_async($"{http_status} {result}");
		//	clipboard_set_text(result);
		//},function(http_status,result){
		//	show_message_async($"{http_status} {result}");
		//});
		file_delete(fpath);
	}
	
	if ( record.enabled ) {
		var finish_func = method({folder, _path_separator, fname, record}, function() { //Finished recording
			var fpath = $"{folder}{_path_separator}{fname}_.gif", fpath_final = $"{program_directory}{_path_separator}{folder}{_path_separator}{fname}_.gif";
			gif_save(record.id_, fpath_final);
			record.frames = 0;
			record.framesmax = 0;
			record.enabled = false;
			record.id_ = -1;
			audio_play_sound(snd_dumbvictory, 0, false);
			execute_shell_simple(fpath_final, , , 6); //Open the image in the PC's default photo viewer (Windows only)
		});
		
		if ( record.type == 0 ) { //No typing animation
			if ( record.frames == 0 ) { record.id_ = gif_open(w_/ smallbox, h_/ smallbox); record.frames++; } //Enable GIF recording
			else { 
				if ( record.frames < record.framesmax ) { gif_add_surface(record.id_, screenshot_surf, 2, x_/ smallbox, y_/ smallbox); record.frames++; } //Add frames to the GIF until we reach our target time
				else { finish_func(); }
			}
		}
		else { //Typing animation
			if ( record.id_ == -1 ) { record.id_ = gif_open(w_/ smallbox, h_/ smallbox); } 
			
			var state_ = typist.get_state();
			if ( state_ < 1 || ( state_ >= 1 && record.frames < 60 ) ) { gif_add_surface(record.id_, screenshot_surf, 2, x_/ smallbox, y_/ smallbox); } //If we're still typing, keep recording
			
			if ( state_ >= 1 ) { //If we stopped typing
				if ( record.frames < 60 ) { record.frames++; }
				else { finish_func(); }
			}
		}
	}
}