/// @ignore
/// feather ignore all
function __CollageTick() {
	static _tp_list = __CollageSystem().__CollageTPLoadedList;
	var _i = 0;
	repeat(ds_list_size(_tp_list)) {
		if (!_tp_list[| _i].__isAlive) {
			_tp_list[| _i].Free(); // Ensure that everything is freed.
			ds_list_delete(_tp_list, _i);
			--_i;
		} else if (_tp_list[| _i].__isLoaded) {
			_tp_list[| _i].CheckSurface();		
		}
		++_i;	
	}
}