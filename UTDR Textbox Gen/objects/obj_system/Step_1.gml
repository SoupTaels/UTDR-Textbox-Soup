///@desc Context Menu, Page Count, Etc.
if ( live_call() ) { return live_result; } 
#region Page Count and Ensure Face
	dial_text_page_c = string_count("[/page]", dial_text) + 1;
	dial_text_page = clamp(dial_text_page, 0, dial_text_page_c - 1);
	
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

#region Context Menu
	var result, txt_ = textinput.GetValue(), select_ = textinput.GetSelection();
	result = textinput.ContextMenuGetItem("soupy_copy");
	result.SetEnabled(txt_ != "" && select_.has_selection);
	result = textinput.ContextMenuGetItem("soupy_cut");
	result.SetEnabled(txt_ != "" && select_.has_selection);
	result = textinput.ContextMenuGetItem("soupy_clear");
	result.SetEnabled(txt_ != "");
	result = textinput.ContextMenuGetItem("soupy_paste");
	result.SetEnabled(clipboard_has_text());
#endregion