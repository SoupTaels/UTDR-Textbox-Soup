///@desc Destroy Everything
outlinesoup_cleanup();
inputbox.destroy();

var i = 0, getfaces = struct_get_names(global.faces_dict), getamt = array_length(getfaces);
repeat ( getamt ) {
	var cur_ = getfaces[i];
	with ( global.faces_dict[$ cur_] ) {
		var getexp = struct_get_names(self), getamt_ = array_length(getexp), i_ = 0;
		repeat ( getamt_ ) {
			self[$ getexp[i_]].destroy();
		i_++; }
	}
i++;	}