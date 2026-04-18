///@desc Check and rescale UI size
function luiRescale(_ui, _width, _height) {
	if !variable_instance_exists(self, "_ui_last_width") variable_instance_set(self, "_ui_last_width", -1);
	if !variable_instance_exists(self, "_ui_last_height") variable_instance_set(self, "_ui_last_height", -1);
	if _ui_last_width != _width || _ui_last_height != _height {
		_ui_last_width = _width;
		_ui_last_height = _height;
		_ui.setSize(_width, _height);
	}
}

///@desc Turn on next debug mode
function luiNextDebugMode() {
	if global.lui_debug_mode < 2 {
		global.lui_debug_mode++;
	} else {
		global.lui_debug_mode = 0;
	}
}

///@desc Toggle debug grid
function luiToggleDebugGrid() {
	global.lui_debug_render_grid = !global.lui_debug_render_grid;
}

