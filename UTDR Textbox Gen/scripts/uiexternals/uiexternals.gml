#region Add External Faces
	face_dict = {}; //Struct to hold all the new faces
	
	/*
		Face sprites will be stripped of its "spr_" and "_strip#.png" label, so to get the face sprites, just reference its name (ex: "undyne_officerpissed", "get_face("alphys", "blush")", etc.)
	*/
	soupTex = new Collage("Externals"); //Create a texture page for these sprites
	soupTex.StartBatch();
		var result = gumshoe("faces", ".png");
		var i_ = 0, countf = array_length(result), folders_ = [];
		repeat ( countf ) {
			var dirname_ = filename_dir_name(result[i_]);
			if ( !array_contains(folders_, dirname_) ) { array_push(folders_, dirname_); } //Pass all unique folders into this array so we can get the count of the total folders
		i_++; }

		for ( var i = 0, count = array_length(folders_), _is_microsoft = ( os_type == os_windows || os_type == os_xboxseriesxs || os_type == os_gdk ), _path_separator = _is_microsoft? "\\"  :  "/"; i < count; i++; ) { //Loop through folders
			var folds_ = folders_[i]; //Get Folders
			if ( !struct_exists(face_dict, folds_) ) { face_dict[$ folds_] = {}; } 
			//show_debug_message($"Folder: {folds_}");
			for ( var f_ = 0, count_ = array_length(result); f_ < count_; f_++; ) { //Loop through folders
				var files_ = result[f_], foldname_ = $"faces{_path_separator}{folds_}{_path_separator}"; //Get Files, Folder Name
				if ( string_search(files_, foldname_, true) ) {
					//show_debug_message(files_);
					var newname_ = string_replace_all(files_, foldname_, ""); //First, remove "Face/(folder name)/"
					var newname_ = string_replace_all(newname_, "spr_", ""), isstrip_ = string_search(newname_, "_strip"); //Then remove "spr_". Check if the string contains "_strip"
					var newname_ = string_letters(newname_); //Then remove anything that isn't the alphabet
					var newname_ = string_replace_all(newname_, isstrip_ ? "strippng" : "png", ""); //Then remove "strippng" or "png"
					var newname_ = string_replace_all(newname_, folds_, $"{folds_}_"); //Finally, add back the underscore. Finished! Now we can call for their sprites using this identifier, rather than having to search through an array.
					//show_debug_message(newname_);
					soupTex.AddFileStrip(files_, newname_, , , CollageOrigin.CENTER, CollageOrigin.CENTER); //Add sprite to texture pack
					var expr_ = string_replace_all(newname_, $"{folds_}_", ""); 
					with ( face_dict[$ folds_] ) { struct_set(self, expr_, { name: expr_, expression: newname_,}); } //Add to face dictonary
				}
			}
		}
	soupTex.FinishBatch();
	soupTex = soupTex.ToStatic(true, true); //Send these sprites to one big texture page, rather than what GM does by default and sends every sprite, every frame, to separate texture pages(not great for performance)
	
	///@desc Returns the sprite index of an externally loaded face sprite
	function get_face(name_, expression_) {
		var face_ = global.face_dict[$ name_];
		return face_[$ expression_].expression;
	}
	
	///@desc Returns the struct of an externally loaded face sprite's expression
	function get_face_data(name_, expression_) {
		var face_ = global.face_dict[$ name_];
		return face_[$ expression_];
	}
	
	///@desc Returns the struct of an externally loaded face sprite
	function get_face_all(name_) { return global.face_dict[$ name_]; }
#endregion

#region Add External Icons and Borders
	soupTex_IB = new Collage("Externals IB"); //Create a texture page for these sprites
	soupTex_IB.StartBatch();
		/*
			Borders will be stripped of its "spr_" and "_strip#.png" label, so to get the border, just reference its name (ex: "custom_border_example", "custom_border_example_two", etc.)
		*/
		var result_b = gumshoe("borders", ".png");
		for ( var i = 0, count = array_length(result_b), _is_microsoft = ( os_type == os_windows || os_type == os_xboxseriesxs || os_type == os_gdk ), _path_separator = _is_microsoft? "\\"  :  "/"; i < count; i++; ) { //Loop through folders
			var bords_ = result_b[i];
			var name_ = string_replace_all(string_replace_all(string_replace_all(bords_, $"borders{_path_separator}", ""), ".png", ""), "spr_", "");
			soupTex_IB.AddFileStrip(bords_, name_, , , CollageOrigin.CENTER, CollageOrigin.CENTER); //Add sprite to texture pack
		}
		
		/*
			Icons will be stripped of its "spr_" and "_strip#.png" label, so to get the icons, just reference its name (ex: "soupicons", "customicons", etc.)
		*/
		var result_i = gumshoe("icons", ".png");
		for ( var i = 0, count = array_length(result_i), _is_microsoft = ( os_type == os_windows || os_type == os_xboxseriesxs || os_type == os_gdk ), _path_separator = _is_microsoft? "\\"  :  "/"; i < count; i++; ) { //Loop through folders
			var icos_ = result_i[i];
			var name_ = string_letters(string_replace_all(string_replace_all(string_replace_all(string_replace_all(icos_, "_strip", ""), $"icons{_path_separator}", ""), ".png", ""), "spr_", ""));
			soupTex_IB.AddFileStrip(icos_, name_, , , CollageOrigin.CENTER, CollageOrigin.CENTER); //Add sprite to texture pack
		}
	soupTex_IB.FinishBatch();
	soupTex_IB = soupTex_IB.ToStatic(true, true); //Send these sprites to one big texture page, rather than what GM does by default and sends every sprite, every frame, to separate texture pages(not great for performance)
#endregion
