///@desc Dialogue Systems
//if ( live_call() ) { return live_result; } 
if ( bord_out ) { outlinesoup_step(640, 480); }
soupy_lui.update();
#region Clamp Page Count and Ensure Face
	if ( dial_text == "" ) { dial_text_page = 0; dial_text_page_c = 0; }
	dial_text_page = clamp(dial_text_page, 0, dial_text_page_c);
	
	if ( dial_text_page_c > 1 ) { //Prevents out of bounds array reads
		var result = array_length(dial_face);
		if ( result < dial_text_page_c ) { 
			dial_face[dial_text_page_c - 1] = -1;
			dial_face_prev[dial_text_page_c - 1] = -1; 
			dial_face_original[dial_text_page_c - 1] = -1; 
			dial_face_name[dial_text_page_c - 1] = -1; 
		}
	}
#endregion

#region Animation
	if ( dial_text_gif && dial_face_auto && typist.get_delay_paused() ) { dial_face_index = 0; } //Stop the face from animating if the dialogue is being delayed
	if ( bord_spd > 0 ) { //Animate the border
		var amt = sprite_get_number(spr_bord);
		if ( bord_anim == 0 ) { bord_index += bord_spd mod amt; }
		else { 
			if ( !bord_anim_track ) { bord_index += bord_spd mod amt; if ( round(bord_index) >= amt) { bord_anim_track = true; } }
			else { bord_index -= bord_spd; if ( round(bord_index) <= 0) { bord_anim_track = false; } }
		} 
	};
#endregion

#region BG
	var bg = layer_exists("bg3d") ? layer_get_id("bg3d") : layer_create(99, "bg3d"), _fx = layer_get_fx("bg3d"), _params; //Doesn't exist? Create it! Else, get the id.
	if ( _fx == -1 ) { //Doesn't exist? Create it with default values
		_fx = fx_create("_filter_parallax");
		_params = fx_get_parameters(_fx);
		_params.g_ParallaxDirection = [0, 0.54];
		_params.g_ParallaxPerspective = 1;
		_params.g_ParallaxPosition = [0, 1, 0];
		_params.g_ParallaxScale = 0.5;
		_params.g_ParallaxDepth = 0;
		_params.g_ParallaxFogColour = [0, 0, 0, 1];
		_params.g_ParallaxFogRange = [0, 40];
		_params.g_ParallaxFogDepth = 0;
		_params.g_ParallaxTexture = spr_testbg;
		fx_set_parameters(_fx,_params);
	}

	_params = fx_get_parameters(_fx);
	_params.g_ParallaxPosition[0] -= .02;
	_params.g_ParallaxPosition[2] -= .01;
	fx_set_parameters(_fx,_params);
	layer_set_fx("bg3d",_fx);
#endregion

#region Textbox Theme
	if ( obj_system.textinput.IsFocused() ) {
		if ( !quill_change ) { quill_change = true; quill_theme(); }
	}
	else { if ( quill_change ) { quill_change = false; quill_theme(); } }
#endregion

#region Broadcast Signal
	if ( struct_names_count(global.soupsignal) > 0 ) { 
		var sig_ = soupy_alarm("signals", 1, true);
		soupy_alarm_run(sig_.myname_, 0, function () { global.soupsignal = {}; });
	}
#endregion