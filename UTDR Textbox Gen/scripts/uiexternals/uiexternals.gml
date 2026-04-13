#region Add External Faces
	faces_dict = {};
	
	var findfaces = gumshoe("faces", ".png"), faces_i = 0, faces_len = array_length(findfaces), _is_microsoft = ( os_type == os_windows || os_type == os_xboxseriesxs || os_type == os_gdk ), _path_separator = _is_microsoft? "\\"  :  "/";
	repeat ( faces_len ) {
		var faces_cur = findfaces[faces_i]; //Current face we're looking at
		var faces_dir = filename_dir_name(faces_cur); //Get directory name
		if ( !struct_exists(global.faces_dict, faces_dir) ) { global.faces_dict[$ faces_dir] = {}; } //Create new struct face dictionary
	
		var temp_ = string_replace(faces_cur, $"faces{_path_separator}{faces_dir}{_path_separator}", ""); //Remove faces/(folder name)/
		temp_ = string_replace(string_replace(string_replace(temp_, "_strip", ""), ".png", ""), "spr_", ""); //Remove .png, _strip, and spr_
		var temp2 = string_digits(temp_), imgnum = temp2 != "" ? real(temp2) : 1; //Get how many numbers are in this strip image
		temp_ = string_letters(temp_); //Remove anything that isn't a letter
		var faces_emote = string_replace(temp_, faces_dir, ""); //Get face expression
	
		with ( global.faces_dict[$ faces_dir] ) {
			self[$ faces_emote] = { sprite: sprite_add(faces_cur, imgnum, false, false, 0, 0), expression: faces_emote, } //Add sprite index and expression name to the global face dictonary
			with ( self[$ faces_emote] ) { 
				struct_set(self, "destroy", function () { sprite_delete(sprite); delete sprite; sprite = -1; }); //Add a destroy func so we don't get memory leaks
				sprite_set_offset(sprite, sprite_get_width(sprite)/ 2, sprite_get_height(sprite)/ 2); //Center sprite
			}
		}
		faces_i++;
	}
	
	function get_face(name, expression) {
		var face = -1;
		with ( global.faces_dict[$ name] ) { face = self[$ expression].sprite; }
		return face;
	}
	
	function get_face_name(name, expression) {
		var face = -1;
		with ( global.faces_dict[$ name] ) { face = self[$ expression].expression; }
		return face;
	}
#endregion

#region Add Borders and Icons
	icons_dict = {};
	
	var findicons = gumshoe("icons", ".png"), icons_i = 0, icons_len = array_length(findicons), _is_microsoft = ( os_type == os_windows || os_type == os_xboxseriesxs || os_type == os_gdk ), _path_separator = _is_microsoft? "\\"  :  "/";
	repeat ( faces_len ) {
		
	icons_i++; }
#endregion