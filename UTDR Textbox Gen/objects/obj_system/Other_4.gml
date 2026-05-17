///@desc Systems & Error Handler
var tinysoup = "icons\\tinysoupy.png"; if ( file_exists(tinysoup) ) { widget_set_icon(tinysoup); }
undo_stack_create(); //History of undo changes
file_dropper_init(); //Handle file dropping
scribble_font_set_default("fnt_determination_nomono");

#region Error Handling
	if ( file_exists(errname) ) {
		var buff = buffer_load(errname); //Load file
		var err_ = buffer_read(buff, buffer_string); //Read everything the file contains and store it in the variable
		buffer_delete(buff); //Delete buffer to prevent memory leaks
		file_delete(errname); //Delete the file so the game doesn't constantly show this error screen
		instance_create_depth(0, 0, 0, obj_errhandler, { err_ });
	
		if ( file_exists(LAST_SAVED) ) {
			var lasttyped = file_text_open_read(LAST_SAVED);
			var result = file_text_read_string(lasttyped); //Get what the user last typed
			dial_text = result; textinput.SetValue(dial_text);
			file_text_close(lasttyped);
		}
	
		instance_deactivate_object(self);
	}
#endregion