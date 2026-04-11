///@desc Init
live_auto_call_nr
#region Dialogue Box
	outlinesoup_init(, , , , 2);
	spr_bord = spr_border_undertale; //Border Sprite
	bord_clr = c_white; //Border Color
	bord_out = true; //Whether border should have an outline
#endregion

#region Dialogue Text
	dial_text = $"Test dialogue text 1, 2, 3.....{chr(GMIB.CHR_ENTER)}Test dialogue text 4, 5, 6.....{chr(GMIB.CHR_ENTER)}Test dialogue text 7, 8, 9....."; //Dialogue Text
	dial_font = "DEFAULT"; //Dialogue Font
	dial_text_scale = 2; //Text Scale
	dial_updatet = 1; //Dialogue update timer
	
	dial_point_auto = true; //Whether to automatically add points
	dial_point_chr = "*"; //Dialogue Point Character
	dial_point_clr = c_white; //Dialogue Point Clr
	dial_auto_wrap = true; //Whether to automatically wrap dialogue to new lines
	
	if ( !scribble_font_exists("DEFAULT") ) { scribble_font_bake_outline_and_shadow("fnt_determination", "DEFAULT", 1, 1, SCRIBBLE_OUTLINE.NO_OUTLINE, 1, false); }
	scribble_font_set_default("DEFAULT"); //Use the normal dialogue font by default when using Scribble
#endregion

#region Dialogue Shadow
	dial_text_shdw = false; //Whether text should have a shadow
	dial_text_shdw_clr = c_deltarune; //Shadow Color
	dial_text_shdw_thick = 1; //Shadow Thickness
#endregion

#region Dialogue Face
	dial_face = -1; //Dialogue Face
	dial_face_index = 0; //Dialogue Face Frame
	dial_face_clr = c_white; //Dialogue Face Clr
#endregion

#region UI
	fader = 1; TweenFire("$20", "fader>", 0); //Black overlay
	ui_tab = 0; //Current Tab (0 - Dialogue, 1 - Face, 2 - Border, 3 - About)
	screenshot = false; //Screenshot task
	screenshot_surf = -1; //Screenshot surface
	
	///@desc Create a GUI button. Accepts { x, y, text, padd_(x1, y1, x2, y2, multi), sprite, index, scale, font, color, color_butt, halign, and valign, and functions for on_enter(runs once), on_hover, on_leave(once), on_click(once), on_held, on_released(once) }
	///@param {struct} datastruct_ Data struct for button functionality.
	Button = function(datastruct_ = { }) constructor {
		data = datastruct_; button = undefined; on_enter = false on_leave = false;
		data[$ "text"] = undefined ? "Button Text" : data.text;
		data[$ "text_static"] = data.text;

		static update = function() {
			var paddmulti = data[$ "padd_multi"] ?? 0;
			button = scribble(data.text)
							.align(data[$ "halign"] ?? fa_center, data[$ "valign"] ?? fa_middle)
							.starting_format(data[$ "font"] ?? "fnt_determination", data[$ "color"] ?? c_white)
							.scale(data[$ "scale"] ?? 1)
							.padding(data[$ "padd_x1"] ?? 0 + paddmulti, data[$ "padd_y1"] ?? 0 + paddmulti, data[$ "padd_x2"] ?? 0 + paddmulti, data[$ "padd_y2"] ?? 0 + paddmulti);
			
			var x_ = data[$ "x"] ?? 0, y_ = data[$ "y"] ?? 0, bbox = button.get_bbox(x_, y_), leeway = 5;
			draw_sprite_stretched_ext(data[$ "sprite"] ?? spr_pixel, data[$ "index"] ?? 0, bbox.left, bbox.top, bbox.width, bbox.height, data[$ "color_butt"] ?? c_white, 1); //Draw nine-slice sprite
			button.draw(x_, y_); //Draw Scribble text
			
			if ( ( range_within(mouse_x_gui, bbox.left - leeway, bbox.right + leeway) && range_within(mouse_y_gui, bbox.top - leeway, bbox.bottom + leeway) ) && window_has_focus() ) { //If the mouse has enter within the bounding box
				if ( !on_enter ) { on_enter = true; on_leave = false; if ( !is_undefined(data[$ "on_enter"]) ) { data[$ "on_enter"](); } } //Mouse Entered Function
				if ( !is_undefined(data[$ "on_hover"]) ) { data[$ "on_hover"](); } //Mouse Hovering Function
				if ( mouse_pressed ) { if ( !is_undefined(data[$ "on_click"]) ) { data[$ "on_click"](); exit; } } //Mouse Pressed Function
				if ( mouse_check ) { if ( !is_undefined(data[$ "on_held"]) ) { data[$ "on_held"](); } } //Mouse Held Function
				if ( mouse_released ) { if ( !is_undefined(data[$ "on_released"]) ) { data[$ "on_released"](); } } //Mouse Released Function
			}
			else { //If the mouse just left the bounding box
				if ( on_enter ) { if ( !on_leave ) { on_leave = true; on_enter = false; if ( !is_undefined(data[$ "on_leave"]) ) { data[$ "on_leave"](); } } } //Mouse Leave Function
			}
		}
	}
	
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
			c_bkg_focused: { c: #292138, a: 1 },
			c_bkg_unfocused: { c: #524271, a: 1 },
			c_text_unfocused: { c: #9c8cbb, a: 1 },
			c_text_focused: { c: c_white, a: 1 },
			c_selection: { c: c_blue, a: 1 },
		}
		inputbox.update_style(style);
	#endregion
	
#endregion
