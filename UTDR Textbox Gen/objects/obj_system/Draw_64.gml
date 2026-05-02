///@desc Draw Dialogue Things
if ( live_call() ) { return live_result; } 
//draw_format("center", "center");

#region UI Borders and Buttons
	if ( ui_visible ) {
		outlinesoup_start();
			draw_sprite_stretched_ext(spr_border_octagon, 0, 10, 20, room_width - 20, room_height - 90, c_white, 0.6); //Back opacity
			draw_sprite_stretched_ext(spr_border_tabs, 2, 10, 280, room_width - 20, room_height - 350, merge_color(c_orange, c_white, 0.5), 1); //Fading Part
			draw_sprite_stretched_ext(spr_border_tabs, 2, 10, 300, room_width - 20, room_height - 370, c_white, 1); //Bottom
			draw_sprite_stretched_ext(spr_border_tabs, 1, 10, 20, room_width - 20, room_height - 220, c_orange, 1); //Top
		outlinesoup_end();
	}
	
	if ( ui_visible ) {
		var i = 0, count_ = array_length(butt);
		repeat ( count_ ) { 
			butt[i].update();
	
			 var result = butt[i].button.get_bbox(butt[i].data.x, butt[i].data.y);
			 var calc_x = centerizer(result.width, count_, 320, 12);
			butt[i].data.x = calc_x[i];
		i++; }
	}
#endregion

if ( sprite_exists(global.refimg) ) { draw_sprite_ensure(global.refimg, , 0, 0); }

if ( bord_visible ) {
	if ( bord_out ) { outlinesoup_start(); }
		#region Dialogue Box
			var dltrn = spr_bord == spr_border_deltarune; //Check if our border is Deltarune
			var offset_ = dltrn ? 8 : 0, offset_w = dltrn ? 15 : 0, offset_h = dltrn ? 16 : 0, bordx = 32 - offset_, bordy = 315 - offset_, bordw = 578 + offset_w, bordh = 152 + offset_w; //Border coords
			var xx_ = ( bordx + ( ( USING_FACE ? 144 : 28 ) + ( dial_point_auto ? 4 : 0 ) ) ) + ( offset_ + dltrn ? 6 : 0 ), yy_ = ( bordy + 29 ) + offset_; //Text X Y

			var ninesl_ = sprite_get_nineslice(spr_bord ); 
			if ( ninesl_.enabled ) { draw_sprite_stretched_ext(spr_bord, bord_index, bordx, bordy, bordw, bordh, bord_clr, 1); } else { draw_9slice(spr_bord, bord_index, bordx, bordy, bordw, bordh, bord_clr, bord_scale, bord_stretch); } //Dialogue Box
			if ( USING_FACE ) { draw_sprite_ensure(dial_face[dial_text_page], dial_face_index, bordx + ( 74 + offset_ ), bordy + ( 76 + offset_ ), 2, 2, 0, dial_face_clr, 1); } //Dialogue Face
		#endregion

		#region Dialogue Text
			if ( dial_text != "" && dial_text != chr(0) ) { //No need to draw blank text
				var line_sp = dial_text_line_spacing != -1 ? dial_text_line_spacing : ( dial_font == "fnt_monospaced_outline" ? "105%" : "120%" );
				if ( dial_text_shdw ) { //Dialogue Text Shadow
					var scrib_dial_shdw = scribble(dial_text, "dial_shdw") 
					.starting_format(dial_font, c_white)
					.blend(dial_text_shdw_clr, 1)
					.scale(dial_text_scale)
					.page(dial_text_page)
					.line_spacing(line_sp)
					.wrap(dial_auto_wrap ? 580 - xx_ : -1)
					.draw(dial_point_auto ? ( xx_ + dial_text_shdw_thick ) + 28 : xx_ + dial_text_shdw_thick, yy_ + dial_text_shdw_thick);
				}
			
				var scrib_dial = scribble(dial_text) //Dialogue Text
				scrib_dial.starting_format(dial_font, c_white);
				scrib_dial.blend(c_white, 1)
				scrib_dial.scale(dial_text_scale);
				scrib_dial.allow_line_data_getter();
				scrib_dial.allow_glyph_data_getter();
				scrib_dial.line_spacing(line_sp);
				scrib_dial.page(dial_text_page);
				dial_text_page_c = scrib_dial.get_page_count();
				scrib_dial.outline(dial_text_outline);
				scrib_dial.wrap(dial_auto_wrap ? 580 - xx_ : -1);
				scrib_dial.draw(dial_point_auto ? xx_ + 28 : xx_, yy_, dial_text_gif ? typist : undefined);

				#region Dialogue Auto Point
					if ( dial_point_auto ) {
						var linec = dial_text_gif ? dial_wrap_count : scrib_dial.get_line_count(dial_text_page);
						var i = 0; repeat ( linec ) {
							var lined = scrib_dial.get_line_data(i, dial_text_page), chr_ = chr(scrib_dial.get_glyph_data(lined.glyph_start, dial_text_page).unicode);
							if ( lined.forced_break && ( chr_ != chr(10) && chr_ != chr(0) ) ) { //Don't show anything if the line only contains an newline literal
								if ( dial_text_shdw ) { 
									var scrib_point_shdw = scribble(dial_point_chr, "point_shdw"); //Dialogue Point
									scrib_point_shdw.starting_format(dial_font, dial_text_shdw_clr);
									scrib_point_shdw.scale(dial_text_scale);
									scrib_point_shdw.draw(( xx_ + dial_text_shdw_thick ) - 4, ( yy_ + lined.y ) + dial_text_shdw_thick);
								}
								
								var scrib_point = scribble(dial_point_chr); //Dialogue Point
								scrib_point.starting_format(dial_font, dial_point_clr);
								scrib_point.scale(dial_text_scale);
								scrib_point.allow_line_data_getter();
								scrib_point.outline(dial_text_outline); 
								scrib_point.draw(xx_ - 4, yy_ + lined.y);
							}
						i++; }
					}
				#endregion
			}
		#endregion
	if  ( bord_out ) { outlinesoup_end(); }
}

#region UI
	ui_manage();
	
	draw_sprite_ext(spr_pixel, 0, 0, 0, 640, 480, 0, c_black, fader);
#endregion

if ( file_dragging ) { //Receive signal for file dragging
	//Portrait
	if ( bord_visible ) {
		draw_sprite_stretched_ext(spr_border_dashed, 0, 40, 323, 134, 136, c_yellow, 0.5 + abs(sin(current_time/300)) * 0.5);
		draw_format("center", "center", fnt_speech, c_yellow);
		draw_text(108, 390, "Drag your\nsprite here\nto change\nthe dialogue\nportrait!\n(.PNG ONLY)");
		
		//Border
		draw_sprite_stretched_ext(spr_border_dashed, 0, 190, 315, 420, 153, c_red, 0.5 + abs(sin(current_time/300)) * 0.5);
		draw_format("center", "center", fnt_speech, c_red);
		draw_text(400, 390, "Drag your sprite here to change\nthe dialogue border!\n(.PNG ONLY)");
	}
	
	//Textbox
	if ( ui_tab == 0 ) {
		draw_sprite_stretched_ext(spr_border_dashed, 0, 35, 135, 605 - 35, bord_visible ? 285 - 135 : 235, c_cyan, 0.5 + abs(sin(current_time/300)) * 0.5);
		draw_format("center", "center", fnt_speech, c_cyan);
		draw_text(320, bord_visible ? 210 : 255,  "Drag your text document here to copy over its contents!\n(.TXT ONLY)");
	}
}

soupy_lui.render();
mouse_debug();
//draw_sprite_ensure(get_face("sck", "capn"), current_time/300, 320, 240);
//draw_sprite_ensure(get_face("undyne", "pissed"), current_time/300, 320 + 40, 240);
//draw_sprite_ensure(get_face("sans", "funny"), current_time/300, 320 + 80, 240);