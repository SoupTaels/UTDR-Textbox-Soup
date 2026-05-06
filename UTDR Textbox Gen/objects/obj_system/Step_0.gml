///@desc BG, Signals, Etc.
//if ( live_call() ) { return live_result; } 
if ( bord_out ) { outlinesoup_step(640, 480); }
soupy_lui.update();

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

#region Broadcast Signal
	if ( struct_names_count(global.soupsignal) > 0 ) { 
		var sig_ = soupy_alarm("signals", 1, true);
		soupy_alarm_run(sig_.myname_, 0, function () { global.soupsignal = {}; });
	}
#endregion

#region Fullscreen, Debug
	if ( keyboard_check_pressed(vk_f2) ) { event_perform(ev_create, 0); }
	if ( keyboard_check_pressed(vk_f4) ) { window_set_fullscreen( !window_get_fullscreen() ); sfx_play(snd_equip2); }
#endregion