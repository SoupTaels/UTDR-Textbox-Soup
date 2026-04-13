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
	dial_text = $"Test dialogue text 1, 2, 3.....{chr(GMIB.CHR_ENTER)}Test dialogue text 4, 5, 6.....{chr(GMIB.CHR_ENTER)}Test dialogue text 7, 8, 9....."; //Dialogue Text
	dial_font = "DEFAULT"; //Dialogue Font
	dial_text_scale = 2; //Text Scale
	dial_text_gif = false; //Whether to enable typewriting
	dial_updatet = 1; //Dialogue update timer
	
	dial_point_auto = false; //Whether to automatically add points
	dial_point_chr = "*"; //Dialogue Point Character
	dial_point_clr = c_white; //Dialogue Point Clr
	dial_auto_wrap = true; //Whether to automatically wrap dialogue to new lines
	dial_wrap_count = 1; //Current wrapped line
	
	if ( !scribble_font_exists("DEFAULT") ) { scribble_font_bake_outline_and_shadow("fnt_determination", "DEFAULT", 1, 1, SCRIBBLE_OUTLINE.NO_OUTLINE, 1, false); }
	scribble_font_set_default("DEFAULT"); //Use the normal dialogue font by default when using Scribble
	
	typist = scribble_typist();
	typist.in(0.4, 0);
	typist.function_per_char(function(_element, _position, _typist) { //Function to run per character
		var mychr = chr(_element.get_glyph_data(_position-1).unicode); //Get the currently revealed character
		//show_debug_message(mychr);
		if ( mychr == chr(10) ) { dial_wrap_count++; } //Newline
		
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
			dial_face = param[0]; //Switch to new face
		});
		scribble_typists_add_event("face_original", function(_, param) { //Change the original previous face to a new 
			DIAL_GIF
			dial_face_original = param[0];
		});
		scribble_typists_add_event("face_prev", function(_, param) { //Change the face back to the previous face
			DIAL_GIF
			dial_face = dial_face_prev;
		});
		scribble_typists_add_event("face_auto", function(_, param) { //Switch the automatically animation of the face
			DIAL_GIF
			dial_face_auto = bool(string_letters(param[0]));
		});
		scribble_typists_add_event("face_index", function(_, param) { //Change the index of the face(if dial_face_auto is off), for sprites with more sprites and expressions
			DIAL_GIF
			dial_face_index = real(string_digits(param[0]));
		});
		scribble_typists_add_event("border", function(_, param) { //Switch to a new border sprite
			DIAL_GIF
			var bord_ = asset_get_index(param[0]);
			spr_bord = bord_ != -1 ? bord_ : spr_border_undertale;
		});
		
		scribble_add_macro("newline", function(){ return "[offsetPop]\n    [offset,-4]"; }); //Newline with no asterisk
		scribble_add_macro("newline_new", function(){ return "[offsetPop]\n* "; }); //Newline with asterisk
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
	fader = 1; TweenFire("$20", "fader>", 0); //Black overlay
	ui_tab = 0; //Current Tab (0 - Dialogue, 1 - Face, 2 - Border, 3 - About)
	screenshot = false; //Screenshot task
	screenshot_surf = -1; //Screenshot surface
	record = { enabled: false, type: 0, frames: 0, framesmax: 0, id_: -1, }; //Whether to record, the type of recording(0 - static, 1 - wait for dialogue to finish), and how long to record for
	
	#region Main Menu Buttons
		var i = 0, spr_ = spr_border_octagon, y_ = 12, clr_ = c_orange, padd_ = 14;
		butt[i] = new Button({ id_: i, text: "Dialogue [spr_gui_icons,0]", x: 320, y: y_, ystart: y_, padd_multi: padd_, sprite: spr_, color_butt: clr_, color: clr_, on_enter: undefined, on_leave: undefined, on_click: undefined });
		with ( butt[i].data ) {
			on_click = function() { on_click_(); } on_enter = function() { on_enter_(); } on_leave = function() { on_leave_(); }
		} i++;
		
		butt[i] = new Button({ id_: i, text: "Style        [spr_gui_icons,5]", x: 320, y: y_, ystart: y_, padd_multi: padd_, sprite: spr_, color_butt: clr_, color: clr_, on_enter: undefined, on_leave: undefined, on_click: undefined });
		with ( butt[i].data ) {
			on_click = function() { on_click_(); } on_enter = function() { on_enter_(); } on_leave = function() { on_leave_(); }
		} i++;
	
		butt[i] = new Button({ id_: i, text: "Portrait [spr_gui_icons,1]", x: 320, y: y_, ystart: y_, padd_multi: padd_, sprite: spr_, color_butt: clr_, color: clr_, on_enter: undefined, on_leave: undefined, on_click: undefined });
		with ( butt[i].data ) {
			on_click = function() { on_click_(); } on_enter = function() { on_enter_(); } on_leave = function() { on_leave_(); }
		} i++;
	
		butt[i] = new Button({ id_: i, text: "Border      [spr_gui_icons,2]", x: 320, y: y_, ystart: y_, padd_multi: padd_, sprite: spr_, color_butt: clr_, color: clr_, on_enter: undefined, on_leave: undefined, on_click: undefined });
		with ( butt[i].data ) {
			on_click = function() { on_click_(); } on_enter = function() { on_enter_(); } on_leave = function() { on_leave_(); }
		} i++;
	
		butt[i] = new Button({ id_: i, text: "About        [spr_gui_icons,3]", x: 320, y: y_, ystart: y_, padd_multi: padd_, sprite: spr_, color_butt: clr_, color: clr_, on_enter: undefined, on_leave: undefined, on_click: undefined});
		with ( butt[i].data ) {
			on_click = function() { on_click_(); } on_enter = function() { on_enter_(); } on_leave = function() { on_leave_(); }
		} i++;
			
		call_later(1, time_source_units_frames, on_reset_); //Reset all buttons on start
	#endregion
	
	#region Input Box
		inputbox = new gmib({ w: 580, h: 180, font: fnt_speech, textscalefactor: 1, text: dial_text, cursor_blinks: false, cursor_spd: 300, }); //Create new input box and set the style of it
		inputbox.focus(); //Make the input box immediately stay focused
		var style = { //Set more styles
			c_bkg_focused: { c: #292138, a: 1, },
			c_bkg_unfocused: { c: #524271, a: 1, },
			c_text_unfocused: { c: #9c8cbb, a: 1, },
			c_text_focused: { c: c_white, a: 1, },
			c_selection: { c: c_blue, a: 1, },
		}
		inputbox.update_style(style);
	#endregion
#endregion