///@desc Destroy Everything
undo_stack_destroy();
outlinesoup_cleanup();
window_set_cursor(cr_default);
soupy_lui.destroy(); 

#region Destroy Faces
	var i = 0, getfaces = struct_get_names(global.faces_dict_alt), getamt = array_length(getfaces);
	repeat ( getamt ) {
		var cur_ = getfaces[i], get_ = global.faces_dict_alt[$ cur_];
		get_.destroy();
	i++;	}
	show_debug_message($"Over {getamt} external faces were destroyed!");
#endregion

#region Destroy Icons, Border, Fonts, and Reference Image
	#region Icons
		var i_ = 0, geticons = struct_get_names(global.icons_dict), getamt = array_length(geticons);
		repeat ( getamt ) {
			var cur_ = geticons[i_];
			global.icons_dict[$ cur_].destroy();
		i_++;	}
	#endregion
	
	#region Borders
		var i__ = 0, getbords = struct_get_names(global.bords_dict), getamt = array_length(getbords);
		repeat ( getamt ) {
			var cur_ = getbords[i__];
			global.bords_dict[$ cur_].destroy();
		i__++;	}
	#endregion
	
	#region Fonts
		var i___ = 0, getfonts = struct_get_names(global.fonts_dict), getamt = array_length(getfonts);
		repeat ( getamt ) {
			var cur_ = getfonts[i___];
			global.fonts_dict[$ cur_].destroy();
		i___++;	}
	#endregion
	
	if ( sprite_exists(global.refimg) ) { sprite_delete(global.refimg); show_debug_message("Reference image was destroyed and cleared from memory!"); }
#endregion