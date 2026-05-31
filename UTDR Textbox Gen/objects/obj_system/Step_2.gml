///@desc 3D BG
#region BG

	if ( ui_visible && global.pref.bg3d && !sprite_exists(global.refimg) ) {
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
	}
	else { if ( layer_exists("bg3d") ) { layer_destroy("bg3d"); } }
	
	if ( mouse_pressed && ui_viewing ) { ui_unviewref(); }
#endregion