///@desc Destroy Everything
outlinesoup_cleanup();
soupGUI.Free(); delete soupGUI;
undo_stack_destroy();

#region Destroy Faces
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
#endregion

#region Destroy Icons, Border, and Reference Image
	#region Icons
		var i = 0, geticons = struct_get_names(global.icons_dict), getamt = array_length(geticons);
		repeat ( getamt ) {
			var cur_ = geticons[i];
			global.icons_dict[$ cur_].destroy();
		i++;	}
	#endregion
	
	#region Borders
		var i = 0, getbords = struct_get_names(global.bords_dict), getamt = array_length(getbords);
		repeat ( getamt ) {
			var cur_ = getbords[i];
			global.bords_dict[$ cur_].destroy();
		i++;	}
	#endregion
	
	if ( sprite_exists(global.refimg) ) { sprite_delete(global.refimg); show_debug_message("Reference image was destroyed and cleared from memory!"); }
#endregion