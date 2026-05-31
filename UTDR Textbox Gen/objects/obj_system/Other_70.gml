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
}