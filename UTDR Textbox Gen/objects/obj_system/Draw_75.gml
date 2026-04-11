///@desc Screenshot task
if ( screenshot ) { 
	var dltrn = spr_bord == spr_border_deltarune; //Check if our border is Deltarune
	var out_ = bord_out; //Whether to save with an outline
	var folder = "UTDR-SoupGen-Export", fname = "UTDR_SoupGen";
	var x_ = ( dltrn ? 24 : 32 ) - ( out_ ? 2 : 0 ), y_ = ( dltrn ? 312 : 320 ) - ( out_ ? 2 : 0 ), w_ = ( dltrn ? 593 : 578 ) + ( out_ ? 4 : 0 ), h_ = ( dltrn ? 167 : 152 ) + ( out_ ? 4 : 0 );

	screenshot_surf = surface_create(640, 480);
	surface_set_target(screenshot_surf);
		draw_clear_alpha(c_black, 0);
		draw_sprite_ext(spr_pixel, 0, 0, 0, 640, 480, 0, c_black, 1); //Our outline, if enabled
		draw_surface(out_surf, 0, 0);
	surface_reset_target();

	var i = 0, fpath, fpath2;
	do { fpath = $"{folder}/{fname}_{i}.png"; fpath2 = $"{program_directory}/{folder}/{fname}_{i}.png"; i++; } until ( !file_exists(fpath) ); //Increment number of screenshots
	
	surface_save_part(screenshot_surf, fpath, x_, y_, w_, h_); //Save output temp
	surface_save_part(screenshot_surf, fpath2, x_, y_, w_, h_); //Save output
	surface_free(screenshot_surf);
	screenshot_surf = -1;
	
	show_debug_message($"{fpath} saved!");
	screenshot = false;

	var form = new FormData();
	form.add_data("reqtype", "fileupload");
	form.add_data("time", "1h");
	form.add_file("fileToUpload", fpath);
	http("https://litterbox.catbox.moe/resources/internals/api.php", "POST", form, , function(http_status, result) {
		show_message_async($"{http_status} {result}");
	},function(http_status,result){
		show_message_async($"{http_status} {result}");
	});
}
