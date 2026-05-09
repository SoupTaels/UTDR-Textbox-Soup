///@desc Draw Dialogue Things
//if ( live_call() ) { return live_result; } 
#region UI Borders and Buttons
	if ( ui_visible ) {
		#region Orange and White Border
			outlinesoup_start();
				var yoff = ui_tab_yoff;
				draw_sprite_stretched_ext(spr_border_octagon, 0, 10, 20, room_width - 20, ( room_height - 90 ) + yoff, c_white, 0.6); //Back opacity
				draw_sprite_stretched_ext(spr_border_tabs, 2, 10, 280, room_width - 20, ( room_height - 350 ) + yoff, merge_color(c_orange, c_white, 0.5), 1); //Fading Part
				draw_sprite_stretched_ext(spr_border_tabs, 2, 10, 300, room_width - 20, ( room_height - 370 ) + yoff, c_white, 1); //Bottom
				draw_sprite_stretched_ext(spr_border_tabs, 1, 10, 20, room_width - 20, ( room_height - 220 ), c_orange, 1); //Top
			outlinesoup_end();
		#endregion
		
		#region Menu Buttons
			var i = 0, count_ = array_length(butt);
			repeat ( count_ ) { 
				butt[i].update();
	
				 if ( !butt[i].data.centered ) {
					 var result = butt[i].button.get_bbox(butt[i].data.x, butt[i].data.y);
					 var calc_x = centerizer(result.width, count_, 320, 12);
					butt[i].data.x = calc_x[i]; butt[i].data.centered = true;
				 }
			i++; }
		#endregion
	}
#endregion

if ( sprite_exists(global.refimg) ) { draw_sprite_ensure(global.refimg, , 0, 0); } //Reference image

#region Dialogue Box, Text, Face, etc.
	if ( bord_visible ) {
		outlinesoup_start();
			#region Dialogue Box
				var dltrn = spr_bord == spr_border_deltarune; //Check if our border is Deltarune
				var offset_ = dltrn ? 8 : 0, offset_w = dltrn ? 15 : 0, offset_h = dltrn ? 16 : 0, bordx = 32 - offset_, bordy = 315 - offset_, bordw = 578 + offset_w, bordh = 152 + offset_w; //Border coords
				var xx_ = ( bordx + ( ( FACE_USING ? 144 : 28 ) + ( dial_point_auto ? 4 : 0 ) ) ) + ( offset_ + dltrn ? 6 : 0 ), yy_ = ( bordy + 29 ) + offset_; //Text X Y

				var ninesl_ = sprite_get_nineslice(spr_bord); 
				if ( bord_box_visible ) { if ( ninesl_.enabled ) { draw_sprite_stretched_ext(spr_bord, bord_index, bordx, bordy, bordw, bordh, bord_clr, 1); } else { draw_9slice(spr_bord, bord_index, bordx, bordy, bordw, bordh, bord_clr, bord_scale, bord_stretch); } } //Dialogue Box
				if ( FACE_USING ) { draw_sprite_ensure(FACE_CURRENT, dial_face_index, bordx + ( 74 + offset_ ) + dial_face_xoff, bordy + ( 76 + offset_ ) + dial_face_yoff, dial_face_xscale + dial_face_xscale_off, dial_face_yscale + dial_face_yscale_off, dial_face_angle, dial_face_clr, dial_face_alpha); } //Dialogue Face
				if ( FACE_USING && dial_point_clr_anim_alpha > 0 ) { gpu_set_fog(true, dial_point_clr_anim, -16000, 16000); draw_sprite_ensure(FACE_CURRENT, dial_face_index, bordx + ( 74 + offset_ ) + dial_face_xoff, bordy + ( 76 + offset_ ) + dial_face_yoff, dial_face_xscale + dial_face_xscale_off, dial_face_yscale + dial_face_yscale_off, dial_face_angle, c_white, dial_point_clr_anim_alpha); gpu_set_fog(false, 0, 0, 0); } //Dialogue Face Flashing
			#endregion

			#region Dialogue Text
				if ( dial_text != "" && dial_text != chr(0) ) { //No need to draw blank text
					var line_sp = dial_text_line_spacing != -1 ? dial_text_line_spacing : "130%";
					#region Dialogue Text Shadow
						if ( dial_text_shdw ) {
							var scrib_dial_shdw = scribble(dial_text, "dial_shdw") 
								.starting_format(dial_font, dial_text_shdw_clr).scale(dial_text_scale)
								.page(dial_text_page).line_spacing(line_sp).wrap(dial_auto_wrap ? 580 - xx_ : -1)
								scrib_dial.draw(dial_point_auto ? ( xx_ + dial_text_shdw_thick ) + 28 : xx_ + dial_text_shdw_thick, yy_ + dial_text_shdw_thick);
						}
					#endregion
			
					#region Actual Text
						var tx_x = dial_point_auto ? xx_ + 28 : xx_, wrapcalc = dial_auto_wrap ? 580 - xx_ : -1;
						if ( dial_text_outline != -1 ) { text_outliner_shitty(tx_x, yy_, line_sp, wrapcalc); } //Outline the text in a very shitty and unoptimized way.
						var scrib_dial = scribble(dial_text) //Dialogue Text
							.starting_format(dial_font, c_white).scale(dial_text_scale)
							.allow_line_data_getter().allow_glyph_data_getter()
							.line_spacing(line_sp).page(dial_text_page).wrap(wrapcalc)
							scrib_dial.draw(tx_x, yy_, dial_text_gif ? typist : undefined);
					#endregion

					#region Dialogue Auto Point
						if ( dial_point_auto ) {
							var linec = dial_text_gif ? dial_wrap_count : scrib_dial.get_line_count(dial_text_page);
							var i = 0; repeat ( linec ) {
								var lined = scrib_dial.get_line_data(i, dial_text_page), chr_ = chr(scrib_dial.get_glyph_data(lined.glyph_start, dial_text_page).unicode);
								if ( lined.forced_break && ( chr_ != chr(10) && chr_ != chr(0) && chr_ != "" && chr_ != " " ) && ( !dial_text_gif || typist.get_state() >= 0.05 * typist_spd ) ) { //Don't show anything if the line only contains an newline literal
									#region Dialogue Asterisk Shadow
										if ( dial_text_shdw ) { 
											var scrib_point_shdw = scribble(dial_point_chr, "point_shdw") //Dialogue Point
												.starting_format(dial_font, dial_text_shdw_clr).scale(dial_text_scale)
												scrib_point_shdw.draw(( xx_ + dial_text_shdw_thick ) - 4, ( yy_ + lined.y ) + dial_text_shdw_thick);
										}
									#endregion
								
									#region Actual Asterisk
										var p_x = xx_ - 4, p_y = yy_ + lined.y;
										if ( dial_text_outline != -1 ) { text_outliner_shitty_point(p_x, p_y); } //Outline the text in a very shitty and unoptimized way.
										var scrib_point = scribble(dial_point_chr) //Dialogue Point
											.starting_format(dial_font, dial_point_clr).scale(dial_text_scale)
											.allow_line_data_getter()
											scrib_point.draw(p_x, p_y);
									#endregion
								}
							i++; }
						}
					#endregion
				}
				else { //Draw placeholders
					if ( FACE_CURRENT == -1 ) {
						var emptytxt = scribble("[c_dkgray][wheel][scale,3](But nobody came.)")
						.align(fa_center, fa_middle)
						.draw(390, 390);
					
						draw_sprite(spr_face_placeholder, 0, 40, 323);  //Portrait placeholder
					}
				}
			#endregion
		outlinesoup_end();
	}
#endregion

ui_manage(); //Menu handler

#region File Dragging
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
#endregion

soupy_lui.render(); //LimeUI
draw_sprite_ext(spr_pixel, 0, 0, 0, 640, 480, 0, c_black, fader); //Black fade overlay

mouse_debug();
//draw_sprite_ensure(get_face("sck", "capn"), current_time/300, 320, 240);
//draw_sprite_ensure(get_face("undyne", "pissed"), current_time/300, 320 + 40, 240);
//draw_sprite_ensure(get_face("sans", "funny"), current_time/300, 320 + 80, 240);