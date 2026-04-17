///@desc Init
//live_auto_call_nr
#region Dialogue Box
	outlinesoup_init(, , , , 2);
	spr_bord = spr_border_undertale; //Border Sprite
	bord_clr = c_white; //Border Color
	bord_out = true; //Whether border should have an outline
	bord_small = false; //Whether to render everything out in a small box
	bord_prev = spr_bord; //Previous border
#endregion

#region Dialogue Text
	dial_text = $""; //Dialogue Text
	//dial_text = $"Test dialogue text 1, 2, 3.....\nTest dialogue text 4, 5, 6.....\nTest dialogue text 7, 8, 9.....";
	dial_font = "fnt_monospaced"; //Dialogue Font
	dial_text_scale = 2; //Text Scale
	dial_text_gif = false; //Whether to enable typewriting
	dial_updatet = 0; //Dialogue update timer
	dial_updatet_max = 30; //Dialogue update timer delay
	
	undo_stack_create(); //History of undo changes
	
	dial_point_auto = true; //Whether to automatically add points
	dial_point_chr = "*"; //Dialogue Point Character
	dial_point_clr = c_white; //Dialogue Point Clr
	dial_auto_wrap = true; //Whether to automatically wrap dialogue to new lines
	dial_wrap_count = 0; //Current wrapped line
	
	if ( !scribble_font_exists("fnt_default") ) { scribble_font_bake_outline_and_shadow("fnt_determination_nomono", "fnt_default", 1, 1, SCRIBBLE_OUTLINE.NO_OUTLINE, 1, false); }
	if ( !scribble_font_exists("fnt_monospaced") ) { scribble_font_bake_outline_and_shadow("fnt_determination", "fnt_monospaced", 1, 1, SCRIBBLE_OUTLINE.NO_OUTLINE, 0, false); }
	scribble_font_set_default("fnt_default"); //Use the normal dialogue font by default when using Scribble
	
	typist = scribble_typist();
	typist.in(0.4, 0);
	typist.function_per_char(function(_element, _position, _typist) { //Function to run per character
		var mychr = chr(_element.get_glyph_data(_position-1).unicode); //Get the currently revealed character
		//show_debug_message(mychr);
		if ( mychr == chr(GMIB.CHR_DOWN) ) { dial_wrap_count++; } //Newline
		
		if ( dial_face_auto ) { //Animate the face while dialogue is typing out
			static anim_timer = 0; anim_timer++;
			if ( anim_timer > 2 ) { anim_timer = 0; dial_face_index++; }
		}
	});
	
	typist.function_on_complete(function() { //Function to run once the dialogue is complete
		dial_face_index = 0;
		dial_face = dial_face_original; //Switch back to the original face
	});
	
	#region Typist Events
		scribble_typists_add_event("face", function(_, param) { //Switch to a new portrait sprite
			DIAL_GIF
			dial_face_prev = dial_face; //Get the previous face
			dial_face = get_face(param[0], array_length(param) > 1 ? param[1] : -1);
		});
		scribble_typists_add_event("face_orig", function(_, param) { DIAL_GIF dial_face_original = get_face(param[0], array_length(param) > 1 ? param[1] : -1); }); //Change the original previous face to a new 
		scribble_typists_add_event("face_prev", function(_, param) { DIAL_GIF dial_face = dial_face_prev; }); //Change the face back to the previous face
		scribble_typists_add_event("face_auto", function(_, param) { DIAL_GIF dial_face_auto = bool(string_letters(param[0])); }); //Switch the automatically animation of the face
		scribble_typists_add_event("face_index", function(_, param) { DIAL_GIF dial_face_index = real(string_digits(param[0])); }); //Change the index of the face(if dial_face_auto is off), for sprites with more sprites and expressions
		scribble_typists_add_event("border", function(_, param) { //Switch to a new border sprite
			DIAL_GIF
			var bord_ = get_border(param[0]);
			spr_bord = bord_ != -1 ? bord_ : spr_border_undertale;
		});
		
		scribble_add_macro("newl", function(){ return "\n  "; }); //Newline with no asterisk
		scribble_add_macro("newl_a", function(){ return "\n* "; }); //Newline with asterisk
		
		var newsprite = function(face, index_ = 0, speed_ = 0) { //Insert external sprite
			show_debug_message(face);
			var getface = get_face(face);
			if ( getface != -1 ) { return $"[{getface},{real(string_digits(index_ != "" ? index_ : 0))},{real(speed_ != "" ? speed_ : 0)}]"; }
			else {
				var geticon = get_icon(face);
				if ( geticon != -1 ) { return $"[{geticon},{real(string_digits(index_ != "" ? index_ : 0))},{real(speed_ != "" ? speed_ : 0)}]"; }
			}
			return "";
		}
		scribble_add_macro("sprite", newsprite); scribble_add_macro("image", newsprite); scribble_add_macro("icon", newsprite); scribble_add_macro("spr", newsprite); scribble_add_macro("img", newsprite);
	#endregion
#endregion

#region Dialogue Shadow
	dial_text_shdw = false; //Whether text should have a shadow
	dial_text_shdw_clr = c_deltarune; //Shadow Color
	dial_text_shdw_thick = 1; //Shadow Thickness
#endregion

#region Dialogue Face
	dial_face = -1; //Dialogue Face
	dial_face_index = 0; //Dialogue Face Frame
	dial_face_prev = -1; //Previous Dial Face
	dial_face_original = -1; //Original Dial Face
	dial_face_auto = true; //Whether to automatically animate the sprite when dialogue is typing
	dial_face_clr = c_white; //Dialogue Face Clr
#endregion

#region UI
	fader = 1; TweenFire("$10", "+10", "fader>", 0); //Black overlay
	ui_tab = 0; //Current Tab (0 - Dialogue, 1 - Face, 2 - Border, 3 - About)
	screenshot = false; //Screenshot task
	screenshot_surf = -1; //Screenshot surface
	record = { enabled: false, type: 0, frames: 0, framesmax: 0, id_: -1, }; //Whether to record, the type of recording(0 - static, 1 - wait for dialogue to finish), and how long to record for
	ui_visible = true; //Whether the UI should be visible
	ui_effoff = 0; //Effects array offset 
	
	#region Main Menu Buttons
		var i = 0, spr_ = spr_border_octagon, y_ = 12, clr_ = c_orange, padd_ = 14;
		butt[i] = new Button({ id_: i, text: "Dialogue [spr_gui_icons,0]", x: 320, y: y_, ystart: y_, padd_multi: padd_, sprite: spr_, color_butt: clr_, color: clr_, on_hover: on_hover_, on_enter: undefined, on_leave: undefined, on_click: undefined });
		with ( butt[i].data ) {
			on_click = function() { on_click_(); } on_enter = function() { on_enter_(); } on_leave = function() { on_leave_(); }
		} i++;
		
		butt[i] = new Button({ id_: i, text: "Style        [spr_gui_icons,5]", x: 320, y: y_, ystart: y_, padd_multi: padd_, sprite: spr_, color_butt: clr_, color: clr_, on_hover: on_hover_, on_enter: undefined, on_leave: undefined, on_click: undefined });
		with ( butt[i].data ) {
			on_click = function() { on_click_(); } on_enter = function() { on_enter_(); } on_leave = function() { on_leave_(); }
		} i++;
	
		butt[i] = new Button({ id_: i, text: "Portrait [spr_gui_icons,1]", x: 320, y: y_, ystart: y_, padd_multi: padd_, sprite: spr_, color_butt: clr_, color: clr_, on_hover: on_hover_, on_enter: undefined, on_leave: undefined, on_click: undefined });
		with ( butt[i].data ) {
			on_click = function() { on_click_(); } on_enter = function() { on_enter_(); } on_leave = function() { on_leave_(); }
		} i++;
	
		butt[i] = new Button({ id_: i, text: "Border      [spr_gui_icons,2]", x: 320, y: y_, ystart: y_, padd_multi: padd_, sprite: spr_, color_butt: clr_, color: clr_, on_hover: on_hover_, on_enter: undefined, on_leave: undefined, on_click: undefined });
		with ( butt[i].data ) {
			on_click = function() { on_click_(); } on_enter = function() { on_enter_(); } on_leave = function() { on_leave_(); }
		} i++;
	
		butt[i] = new Button({ id_: i, text: "About        [spr_gui_icons,3]", x: 320, y: y_, ystart: y_, padd_multi: padd_, sprite: spr_, color_butt: clr_, color: clr_, on_hover: on_hover_, on_enter: undefined, on_leave: undefined, on_click: undefined});
		with ( butt[i].data ) {
			on_click = function() { on_click_(); } on_enter = function() { on_enter_(); } on_leave = function() { on_leave_(); }
		} i++;
			
		call_later(1, time_source_units_frames, on_reset_); //Reset all buttons on start
	#endregion
	
	#region MajorGUI
		soupGUI = new MajorGUI();
		soupGUI.Setup(new Vector2(640, 480));
		
		textbox_data = { x: 30, y: 130, w: 580, h: 170 };
		textBox = soupGUI.TextboxCreate(new Vector3(textbox_data.x, textbox_data.y), new Vector2(textbox_data.w, textbox_data.h), , 10, , 10, 7);
		soupGUI.TextboxSetFont(textBox, fnt_speech);
		soupGUI.TextboxSetMultiline(textBox, true);
		soupGUI.TextboxSetGhostText(textBox, "(Click here to start typing!)\n(Your raw text input lives here. Processed output is below.)\n(Click on the quick buttons above to quickly insert text colors\n and effects. Try highlighting portions of texts!)\n \n   (Happy generating and make sure to eat some good soup!!)");
		soupGUI.TextboxSetGhostTextColor(textBox, new Vector4(157, 140, 187, 255));
		soupGUI.TextboxSetText(textBox, dial_text);
		TweenScript(id, 0, 10, function() { sfx_play(snd_sparkle); window_mouse_set(320, 240); }); //Everything's loaded!
	#endregion
	
#endregion
