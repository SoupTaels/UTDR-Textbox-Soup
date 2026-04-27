///@desc Init
if ( live_call() ) { return live_result; } 
#region Dialogue Box
	outlinesoup_init(, , , , 2);
	spr_bord = spr_border_undertale; //Border Sprite
	bord_clr = c_white; //Border Color
	bord_out = true; //Whether border should have an outline
	bord_small = false; //Whether to render everything out in a small box
	bord_prev = spr_bord; //Previous border
	bord_visible = true; //Whether the dialogue box is visible
	bord_index = 0; //Border image index
	bord_spd = 0; //Border image speed
	bord_anim = 1; //Animation type ( 0 - Start over, 1 - Bounce back )
	bord_anim_track = 0;
	bord_scale = 1; //Border sprite scale
	bord_stretch = true; //Whether the nineslice border should stretch or tile
#endregion

#region Dialogue Text
	dial_text = $""; //Dialogue Text
	//dial_text = $"Test dialogue text 1, 2, 3.....\nTest dialogue text 4, 5, 6.....\nTest dialogue text 7, 8, 9.....";
	dial_font = "fnt_monospaced"; //Dialogue Font
	dial_text_scale = 2; //Text Scale
	dial_text_gif = false; //Whether to enable typewriting
	dial_updatet = 0; //Dialogue update timer
	dial_updatet_max = 45; //Dialogue update timer delay
	dial_text_outline = c_red; //Dialogue Outline Color
	
	undo_stack_create(); //History of undo changes
	
	dial_point_auto = false; //Whether to automatically add points
	dial_point_chr = "*"; //Dialogue Point Character
	dial_point_clr = c_white; //Dialogue Point Clr
	dial_auto_wrap = true; //Whether to automatically wrap dialogue to new lines
	dial_wrap_count = 1; //Current wrapped line
	
	if ( !scribble_font_exists("fnt_default") ) { scribble_font_bake_outline_and_shadow("fnt_determination_nomono", "fnt_default", 1, 1, SCRIBBLE_OUTLINE.NO_OUTLINE, 1, false); }
	if ( !scribble_font_exists("fnt_monospaced") ) { scribble_font_bake_outline_and_shadow("fnt_determination", "fnt_monospaced", 1, 1, SCRIBBLE_OUTLINE.NO_OUTLINE, 0, false); }
	
	if ( !scribble_font_exists("fnt_default_outline") ) { scribble_font_bake_outline_and_shadow("fnt_determination_nomono", "fnt_default_outline", 1, 1, SCRIBBLE_OUTLINE.EIGHT_DIR, 1, false); }
	if ( !scribble_font_exists("fnt_monospaced_outline") ) { scribble_font_bake_outline_and_shadow("fnt_determination", "fnt_monospaced_outline", 1, 1, SCRIBBLE_OUTLINE.EIGHT_DIR, 0, false); }
	scribble_font_set_default("fnt_default"); //Use the normal dialogue font by default when using Scribble
	
	typist = scribble_typist();
	typist.in(0.4, 0);
	typist.function_per_char(function(_element, _position, _typist) { //Function to run per character
		var mychr = chr(_element.get_glyph_data(_position - 1).unicode); //Get the currently revealed character
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
			dial_face = get_face(param[0], array_length(param) > 1 ? param[1] : -1);
			if ( dial_face != -1 ) { dial_face_name = param[0]; }
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
		scribble_typists_add_event("face_stick", function(_, param) { DIAL_GIF dial_face_original = get_face(dial_face_name); }); //Make the previous dialogue face stick
		
		scribble_add_macro("newl", function() { return "\n  "; }); //Newline with no asterisk
		scribble_add_macro("newl_a", function() { return "\n* "; }); //Newline with asterisk
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
	dial_face_name = -1; //Dialogue Portrait Internal Name
#endregion

#region UI
	fader = 1; TweenFire("$10", "+10", "fader>", 0); //Black overlay
	ui_tab = 0; //Current Tab (0 - Dialogue, 1 - Face, 2 - Border, 3 - About)
	screenshot = false; //Screenshot task
	screenshot_surf = -1; //Screenshot surface
	record = { enabled: false, type: 0, frames: 0, framesmax: 0, id_: -1, quant: 1, }; //Whether to record, the type of recording(0 - static, 1 - wait for dialogue to finish), and how long to record for
	ui_visible = true; //Whether the UI should be visible
	ui_effoff = 0; //Effects array offset 
	debug_restart = false;
	customupload = -1; //String Async ID for getting custom sprites
	uploadstatus = -1; //Upload status(-1 - in progress, true - success, false - failed)
	
	#region Main Menu Buttons
		var i = 0, spr_ = spr_border_octagon, x_ = 320, y_ = 12, clr_ = c_orange, padd_ = 14;
		butt[i] = new Button({ id_: i, text: "Dialogue [spr_gui_icons,0]", x: x_, y: y_, yoff: 0, padd_multi: padd_, sprite: spr_, color_butt: clr_, color: clr_, on_hover: on_hover_, on_enter: undefined, on_leave: undefined, on_click: undefined });
		with ( butt[i].data ) {
			on_click = function() { on_click_(); } on_enter = function() { on_enter_(); } on_leave = function() { on_leave_(); }
		} i++;
		
		butt[i] = new Button({ id_: i, text: "Style        [spr_gui_icons,4]", x: x_, y: y_, yoff: 0, padd_multi: padd_, sprite: spr_, color_butt: clr_, color: clr_, on_hover: on_hover_, on_enter: undefined, on_leave: undefined, on_click: undefined });
		with ( butt[i].data ) {
			on_click = function() { on_click_(); } on_enter = function() { on_enter_(); } on_leave = function() { on_leave_(); }
		} i++;
	
		butt[i] = new Button({ id_: i, text: "Portrait [spr_gui_icons,1]", x: x_, y: y_, yoff: 0, padd_multi: padd_, sprite: spr_, color_butt: clr_, color: clr_, on_hover: on_hover_, on_enter: undefined, on_leave: undefined, on_click: undefined });
		with ( butt[i].data ) {
			on_click = function() { on_click_(); } on_enter = function() { on_enter_(); } on_leave = function() { on_leave_(); }
		} i++;
	
		butt[i] = new Button({ id_: i, text: "Border      [spr_gui_icons,2]", x: x_, y: y_, yoff: 0, padd_multi: padd_, sprite: spr_, color_butt: clr_, color: clr_, on_hover: on_hover_, on_enter: undefined, on_leave: undefined, on_click: undefined });
		with ( butt[i].data ) {
			on_click = function() { on_click_(); } on_enter = function() { on_enter_(); } on_leave = function() { on_leave_(); }
		} i++;
	
		butt[i] = new Button({ id_: i, text: "Extras      [spr_gui_icons,3]", x: x_, y: y_, yoff: 0, padd_multi: padd_, sprite: spr_, color_butt: clr_, color: clr_, on_hover: on_hover_, on_enter: undefined, on_leave: undefined, on_click: undefined});
		with ( butt[i].data ) {
			on_click = function() { on_click_(); } on_enter = function() { on_enter_(); } on_leave = function() { on_leave_(); }
		} i++;
			
		call_later(1, time_source_units_frames, on_reset_); //Reset all buttons on start
	#endregion
	
	#region MajorGUI
		soupGUI = new MajorGUI();
		soupGUI.Setup(new Vector2(640, 480));
		
		textbox_data = { x: 30, y: 130, w: 580, h: 160 };
		textBox = soupGUI.TextboxCreate(new Vector3(textbox_data.x, textbox_data.y), new Vector2(textbox_data.w, textbox_data.h), , 10, , 10, 7);
		soupGUI.TextboxSetFont(textBox, fnt_speech);
		soupGUI.TextboxSetMultiline(textBox, true);
		soupGUI.TextboxSetGhostText(textBox, "(Click here to start typing!)\n(Your raw text input lives here. Processed output is below.)\n(Click on the quick buttons above to quickly insert text colors\n and effects. Try highlighting portions of texts!)\n \n   (Happy generating and make sure to eat some good soup!!)");
		soupGUI.TextboxSetGhostTextColor(textBox, new Vector4(157, 140, 187, 255));
		soupGUI.TextboxSetText(textBox, dial_text);
		TweenScript(id, 0, 10, function() { sfx_play(snd_sparkle); window_mouse_set(320, 240); }); //Everything's loaded!
	#endregion
	
	#region Menu Sections
		#region Init Style
			var soupy_style = new LuiStyle({ padding: 15, gap: 10, color_text: c_white, color_hover: c_yellow, sound_click: snd_select, sound_hover: snd_sel_switch, }) //Main Style
				.setRenderRegionOffset([10, 10, 10, 10])
				.setFonts(fnt_determination, fnt_determination, fnt_determination)
				.setSprites(spr_border_undertale, spr_border_undertale)
				.setColors(, c_orange, #962525)
			soupy_lui = new LuiMain().setStyle(soupy_style);
		#endregion
		
		#region Portrait Panel
			var x1_ = 10, y1_ = 45, x2_ = 600, y2_ = 385, w_ = x2_ - x1_, h_ = y2_ - y1_;
			soupy_panel_portrait = new LuiScrollPanel({ x: 10, y: 45, width: w_, height: h_ }); //Start containter
			soupy_panel_portrait.scroll_pin_edge_offset = 10; soupy_panel_portrait.sprite_panel = false;
		
				portrait_header_cur_panel = new LuiContainer().setPadding(0).addContent([
					new LuiText({ value: "Selected Face:" }),
					new LuiText({ value: "Selected Face:" }),
					new LuiText({ value: "Selected Face:" }),
					new LuiText({ value: "Selected Face:" }),
					new LuiText({ value: "Selected Face:" }),
					new LuiText({ value: "Selected Face:" }),
				]);
				portrait_header_set_panel = new LuiContainer().setPadding(0).addContent([
					new LuiText({ value: "Selected Face: 2" }),
					new LuiText({ value: "Selected Face: 2" }),
					new LuiText({ value: "Selected Face: 2" }),
					new LuiText({ value: "Selected Face: 2" }),
					new LuiText({ value: "Selected Face: 2" }),
					new LuiText({ value: "Selected Face: 2" }),
				]);
		
				var portrait_header_base = { text: "", color: c_orange, sprite_button: spr_pixel, font: fnt_speech, text_color: c_black, sound_click: snd_enc1, sound_click_pitch: 1.3, };
				var portrait_header_cur = new LuiButton(portrait_header_base).setIcon(spr_gui_icons,,, c_black,, 1).addEvent(LUI_EV_CLICK, function() { portrait_header_cur_panel.toggleVisible(); }); portrait_header_cur.text = "Current Face";
				var portrait_header_set = new LuiButton(portrait_header_base).setIcon(spr_gui_icons,,, c_black,, 5).addEvent(LUI_EV_CLICK, function() { portrait_header_set_panel.toggleVisible(); }); portrait_header_set.text = "Face Settings";
			soupy_panel_portrait.addContent([portrait_header_cur, portrait_header_cur_panel, portrait_header_set, portrait_header_set_panel]); //End container
		#endregion

		soupy_lui.addContent([soupy_panel_portrait, ]); //Add everything to the main ui
		
		#region Functions
			///@desc Show/ hide Lui on appropiate screens.
			ui_reset = function() {
				if ( soupy_panel_portrait.visible ) { soupy_panel_portrait.setVisible(false); }
		
				var fx = true;
				switch ( ui_tab ) {
					case 0: { fx = false; } break;
					case 1: {  } break;
					case 2: { soupy_panel_portrait.setVisible(true); } break;
					case 3: {  } break;
					case 4: {  } break;
				}
				if ( fx && bord_visible ) { sfx_play(snd_enc1, 0, , 0.7); bord_visible = false; }
				else if ( !fx && !bord_visible ) { sfx_play(snd_enc1, 0, , 1.3); bord_visible = true; }
			}
		#endregion
		ui_reset();
	#endregion
	
#endregion
