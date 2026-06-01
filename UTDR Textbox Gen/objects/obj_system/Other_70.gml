///@desc Android Stuff
var get_ = async_load;
switch ( get_[? "type"] ) {
	case "saf_request_search_directory_accepted": {
		android_path = async_load[? "path"];
		soup_store("android", $"{android_path}{PATHSEP}", , true);
		var oLog = file_text_open_write($"{soup_checkout("android", false, true)}latest_soupy_run.soupy");
		file_text_write_string(oLog, global.outputLog);
		file_text_close(oLog);
		MobileUtils_Vibrate_Shot(50);
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
		MobileUtils_Vibrate_Shot(150);
		soupy_message("You must define a safe path to save/ load|to in order for SoupGen to work.", "Try Again.", 480, , , snd_error, fnt_abaddon, function(){ intent_saf_request(SAF_REQUEST_SEARCH_DIRECTORY); }, , true, , , fa_top); 
	} break;
	
	case "MobileUtils_Gallery_Open": {
		var result = async_load[? "path"], type = soup_checkout("asynctype", false, true), split_ = string_split(result, "/"), fname = split_[array_length(split_) - 1];
		soup_store("path", result);
		switch ( type ) {
			case "reference": {
				MobileUtils_Vibrate_Shot(150); MobileUtils_Image_Resize(result, 640, 480);
				global.refimg = sprite_add_ext(result, 1, 0, 0, true);
				sfx_play(snd_updated); ui_refclr = c_white; TweenFire("?", SYSTEMUI, "$30", "+60", TPCol("ui_refclr>"), $15101c);
				soup_checkout("asynctype", , true);
			} break;
			
			default: {
				MobileUtils_Vibrate_Shot(50);
				if ( type == "face" && MobileUtils_Image_Height(result) > 70 && MobileUtils_Image_Width(result) > 70 ) { MobileUtils_Image_Resize(result, 70, 70); }
				
				var arr_ = [
					new LuiText({ value: "What will be the name of this sprite?", text_halign: fa_center, text_valign: fa_middle, font: fnt_abaddon, }),
					new LuiText({ value: "Include \"_strip#\" if the image contains multiple frames.", text_halign: fa_center, text_valign: fa_middle, font: fnt_abaddon, }),
					new LuiText({ value: "The name can't be blank, or be a duplicate of another sprite.", text_halign: fa_center, text_valign: fa_middle, font: fnt_abaddon, }),
					new LuiText({ value: "No need to include file extensions(.png, .jpg, etc.).", text_halign: fa_center, text_valign: fa_middle, font: fnt_abaddon, }),
					new LuiInput({ value: "", placeholder: fname, height: 45, offset: 12, type_sfx: snd_txttype, color_normal: c_white, color_hover: c_gray, }).addEvent(LUI_EV_CREATE, function (e_) { soup_store("newname", e_); }),
				];
				var func_ = function() {
					var name_ = soup_checkout("newname").get();
					if ( string_lettersdigits(string_trim(name_)) == "" ) { soupy_message("The name can't be blank.", , , , , snd_error, fnt_abaddon, , true); MobileUtils_Vibrate_Shot(50); exit; }
					else if ( get_icon(name_) != -1 ) { soupy_message("A icon sprite with this alias already exists.", , , , , snd_error, fnt_abaddon, , true); MobileUtils_Vibrate_Shot(50); exit; }
					else { 
						var type = soup_checkout("asynctype", , true);
						switch ( type ) {
							case "face": {
								if ( get_face(name_) != -1 ) { soupy_message("A face sprite with this alias already exists.", , , , , snd_error, fnt_abaddon, , true); MobileUtils_Vibrate_Shot(50); exit; }
								var myname_ = string_exclude(string_replace(string_replace(name_, "_strip", ""), ".png", ""), "0123456789"), result = external_ensure(myname_, $"{name_}.png", soup_checkout("path"), , false);
								var element_ = soup_checkout("element_", , true);
								if ( element_.getData("clear_") ) { FACE_CURRENT = result; FACE_ORIGINAL = FACE_CURRENT; } 
								soup_checkout(element_.getData("inputsoup_"), false, element_.getData("inputglobal_")).set(myname_); 
								soup_checkout(element_.getData("imagesoup_"), false, element_.getData("imageglobal_")).set(result);
								soup_checkout("datafunc", false)();
							} break;
							
							case "border": {
								if ( get_border(name_) != -1 ) { soupy_message("A border sprite with this alias already exists.", , , , , snd_error, fnt_abaddon, , true); MobileUtils_Vibrate_Shot(50); exit; }
								var myname_ = string_exclude(string_replace(string_replace(name_, "_strip", ""), ".png", ""), "0123456789"); result = external_ensure(myname_, $"{name_}.png", soup_checkout("path"), 1, false); 
								SYSTEMUI.spr_bord = result; SYSTEMUI.bord_name = myname_; SYSTEMUI.bord_prev = SYSTEMUI.spr_bord;
								sfx_play(snd_updated); soup_checkout("datainputB", false, true).set(myname_); soup_checkout("dataimageB", false, true).set(result); soup_checkout("datafunc", false)();
							} break;
							
							case "font": {
								if ( get_font(name_) != -1 ) { soupy_message("A font sprite with this alias already exists.", , , , , snd_error, fnt_abaddon, , true); MobileUtils_Vibrate_Shot(50); exit; }
								var myname_ = string_exclude(string_replace(string_replace(name_, "_strip", ""), ".png", ""), "0123456789"); result = external_ensure(myname_, $"{name_}.png", soup_checkout("path"), 2, false); 
								if ( result == -1 || result == "" ) { result = "fnt_determination"; myname_ = result; }
								var element_ = soup_checkout("element_", , true);
								var custom_ = element_.getData("customs");
								if ( custom_ ) { soup_checkout(SYSTEMUI.ui_tab != 4 ? "datainputS" : "datainputbox", false, true).set(myname_); soup_checkout(SYSTEMUI.ui_tab != 4 ? "datafont" : "datafontbox", false, true).font = myname_; sfx_play(snd_updated); }
								else { soup_checkout(soup_checkout("getfont", false, true), false, true).font = myname_; }
								soup_checkout("datafunc", false)();
							} break;
						}
					}
				}
				soupy_popup(arr_, func_, "Rename", , , , snd_dimbox, fnt_abaddon, SYSTEMUI.ui_paused);
			} break;
		}
	} break;
}