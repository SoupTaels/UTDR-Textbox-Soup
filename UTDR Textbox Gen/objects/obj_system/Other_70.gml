///@desc Android Stuff
var get_ = async_load;
switch ( get_[? "type"] ) {
	case "saf_request_search_directory_accepted": {
		android_path = async_load[? "path"];
		soup_store("android", $"{android_path}{PATHSEP}", , true);
		var oLog = file_text_open_write($"{soup_checkout("android", false, true)}latest_soupy_run.soupy");
		file_text_write_string(oLog, global.outputLog);
		file_text_close(oLog);
		ui_loadprefs();
	} break;
	
	case "saf_request_get_directory": {
		android_path = async_load[? "path"];
		if ( android_path == "" ) { android_path = intent_saf_request(SAF_REQUEST_SEARCH_DIRECTORY); exit; }
		soup_store("android", $"{android_path}{PATHSEP}", , true);
		ui_loadprefs();
		sfx_play(snd_dumbvictory);
		soup_checkout("firsttime", , true).destroy();
		ui_paused = false;
		var oLog = file_text_open_write($"{soup_checkout("android", false, true)}latest_soupy_run.soupy");
		file_text_write_string(oLog, global.outputLog);
		file_text_close(oLog);
	} break;
	
	case "saf_request_search_directory_canceled": {
		soupy_message("You must define a safe path to save/ load|to in order for SoupGen to work.", "Try Again.", 480, , , snd_error, fnt_abaddon, function(){ intent_saf_request(SAF_REQUEST_SEARCH_DIRECTORY); }, , true, , , fa_top); 
	} break;
	
	case "saf_request_search_file_accepted": {
		var result = async_load[? "path"], type = soup_checkout("android file", , true);
		
		var _split = string_split(result, "/");
        var _filename = _split[array_length(_split) - 1];

        integrated_file_copy("", result, "/", _filename, IS_FILE, IS_SAF);
		switch ( type ) {
			case "reference": { global.refimg = sprite_add_ext($"{android_path}{_filename}", 1, 0, 0, true); sfx_play(snd_updated); ui_refclr = c_white; TweenFire("?", SYSTEMUI, "$30", "+60", TPCol("ui_refclr>"), $15101c); } break;
			
			case "face": {
				sfx_play(snd_error);
			} break;
		}
	} break;
	
	case "saf_request_search_file_canceled": {
		var type = soup_checkout("android file", , true);
		switch ( type ) {
			case "reference": { sfx_play(snd_error); } break;
			
			case "face": {
				sfx_play(snd_error);
			} break;
		}
	} break;
}