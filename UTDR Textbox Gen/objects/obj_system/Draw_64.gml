///@desc Draw Dialogue Things
if ( live_call() ) { return live_result; } 
if ( dial_text_page > dial_text_page_c - 1 && dial_text_page_c > 1 ) { exit; } //Prevents the stack export from going out of bounds
#region UI Borders and Buttons
	if ( ui_visible ) {
		#region No 3D BG
			if ( !global.pref.bg3d ) {
				draw_sprite_tiled_ext(spr_testbg_1, 0, -current_time/50, -current_time/50, 1, 1, merge_color(ui_accentcolor, c_black, 0.9), 1);
				draw_sprite_tiled_ext(spr_testbg_1, 0, current_time/50, current_time/50, 1, 1, merge_color(ui_accentcolor, c_black, 0.6), 1);
			}
		#endregion
		
		#region Orange and White Border
			outlinesoup_start();
				var yoff = ui_tab_yoff;
				draw_sprite_stretched_ext(spr_border_octagon, 0, 10, 20, room_width - 20, ( room_height - 90 ) + yoff, c_white, 0.6); //Back opacity
				draw_sprite_stretched_ext(spr_border_tabs, 2, 10, 280, room_width - 20, ( room_height - 350 ) + yoff, merge_color(ui_accentcolor, c_white, 0.5), 1); //Fading Part
				draw_sprite_stretched_ext(spr_border_tabs, 2, 10, 300, room_width - 20, ( room_height - 370 ) + yoff, c_white, 1); //Bottom
				draw_sprite_stretched_ext(spr_border_tabs, 1, 10, 20, room_width - 20, ( room_height - 220 ), ui_accentcolor, 1); //Top
			outlinesoup_end();
		#endregion
		
		#region Menu Buttons
			if ( sprite_exists(global.refimg) ) { draw_sprite_ensure(global.refimg, , 0, 0, , , , ui_refclr); } //Reference image
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
		
		if ( ui_tab == 0 ) { 
			var x_ = 30, y_ = 130, w_ = 580, h_ = !bord_visible ? 310 : 160;
			draw_sprite_ensure(spr_pixel, 0, x_ - 10, y_ - 14, w_ + 20, h_ + 24, 0, c_black, 1); //Textbox Outline Outer
			draw_sprite_ensure(spr_pixel, 0, x_ - 8, y_ - 12, w_ + 16, h_ + 20, 0, c_white, 1); //Textbox Outline Inner
			draw_sprite_ensure(spr_pixel, 0, x_ - 2, y_ - 6, w_ + 4, h_ + 8, 0, c_black, 1); //Textbox Inner Shadow and Outline

			textinput.SetReadOnly(!UI_MESSAGE);
			if ( textinput.GetReadOnly() ) { textinput.SetEnabled(false); } else { textinput.SetEnabled(true); }
			textinput.Draw(x_, y_, w_, h_); 
		}
	}
	else if ( !ui_visible && ( ui_viewing || record.enabled ) ) { if ( sprite_exists(global.refimg) ) { draw_sprite_ensure(global.refimg, , 0, 0, , , , ui_refclr); } } //Reference image 
#endregion

#region Dialogue Box, Text, Face, etc.
	if ( bord_visible ) {
		var dltrn = spr_bord == spr_border_deltarune; //Check if our border is Deltarune
		var offset_ = dltrn ? 8 : 0, offset_w = dltrn ? 15 : 0, offset_h = dltrn ? 16 : 0, bordx = 32 - offset_, bordy = ( 315 - offset_ ) - ( ui_viewing && global.pref.sizematters && global.pref.sizematterstop ? 305 + ( global.pref.anyborder ? abs(bord_yoff) : 0 ) : 0 ), bordw = 578 + offset_w, bordh = 152 + offset_w; //Border coords
		var xx_ = ( bordx + ( ( FACE_USING ? ( dial_text_halign == 0 ? 144 : 28 ) : 28 ) + ( AUTO_ASTERISK ? 4 : 0 ) ) ) + ( offset_ + dltrn ? 6 : 0 ), yy_ = ( bordy + 24 ) + offset_; //Text X Y

		var ninesl_ = sprite_get_nineslice(spr_bord); 
		if ( bord_box_visible ) { //Dialogue Box Clone(for transparency issues)
			if ( global.pref.anyborder ) { draw_sprite_ensure(spr_bord, bord_index, bordx + bord_xoff, bordy + bord_yoff, bord_scale, bord_scale, bord_angle, bord_clr, 1); }
			else { if ( ninesl_.enabled ) { draw_sprite_stretched_ext(spr_bord, bord_index, bordx, bordy, bordw, bordh, bord_clr, 1); } else { draw_9slice(spr_bord, bord_index, bordx, bordy, bordw, bordh, bord_clr, bord_scale, bord_stretch); } }
		}
		outlinesoup_start();
		
			#region Dialogue Box
				if ( bord_box_visible ) { //Dialogue Box
					if ( global.pref.anyborder ) { draw_sprite_ensure(spr_bord, bord_index, bordx + bord_xoff, bordy + bord_yoff, bord_scale, bord_scale, bord_angle, bord_clr, 1); }
					else { if ( ninesl_.enabled ) { draw_sprite_stretched_ext(spr_bord, bord_index, bordx, bordy, bordw, bordh, bord_clr, 1); } else { draw_9slice(spr_bord, bord_index, bordx, bordy, bordw, bordh, bord_clr, bord_scale, bord_stretch); } }
					if ( dial_indicator != -1 && dial_indicator_visible && blink(dial_indicator_blink - 100, dial_indicator_blink) ) { draw_sprite_ensure(dial_indicator, dial_indicator_index, ( 600 - ( sprite_get_width(dial_indicator) )/ 2 ) + dial_indicator_xoff, ( ( 455 - ( sprite_get_height(dial_indicator) )/ 2 ) + dial_text_yoff ) + dial_indicator_yoff, dial_indicator_scale, dial_indicator_scale, dial_indicator_angle, dial_text_c, 1); }
				}
				
				#region Name Tag
					if ( string_lettersdigits(dial_nametag) != "" ) { 
						var nametag_ = scribble(dial_nametag).starting_format("fnt_tiny", dial_text_c).scale(2), x_ = bordx + 20, y_ = bordy - 2;
						var bbox_ = nametag_.get_bbox(x_, y_);
						draw_sprite_ext(spr_pixel, 0, x_ - 2, y_, bbox_.width + 2, bbox_.height - 3, 0, c_black, 1);
						nametag_.draw(x_, y_);
					}
				#endregion
				
				if ( FACE_USING && ( !dial_text_gif || ( dial_text_gif && typist.get_state() >= 0.01 * typist_spd ) ) ) { draw_sprite_ensure(FACE_CURRENT, FACE_INDEX, bordx + ( 74 + offset_ ) + dial_face_xoff, bordy + ( 76 + offset_ ) + dial_face_yoff, dial_face_xscale + dial_face_xscale_off, dial_face_yscale + dial_face_yscale_off, dial_face_angle, dial_face_clr, dial_face_alpha); } //Dialogue Face
				if ( ( FACE_USING && ( !dial_text_gif || ( dial_text_gif && typist.get_state() >= 0.01 * typist_spd ) ) ) && dial_point_clr_anim_alpha > 0 ) { gpu_set_fog(true, dial_point_clr_anim, -16000, 16000); draw_sprite_ensure(FACE_CURRENT, FACE_INDEX, bordx + ( 74 + offset_ ) + dial_face_xoff, bordy + ( 76 + offset_ ) + dial_face_yoff, dial_face_xscale + dial_face_xscale_off, dial_face_yscale + dial_face_yscale_off, dial_face_angle, c_white, dial_point_clr_anim_alpha); gpu_set_fog(false, 0, 0, 0); } //Dialogue Face Flashing
			#endregion

			#region Dialogue Text
				if ( dial_text != "" && dial_text != chr(0) ) { //No need to draw blank text
					var line_sp = dial_text_line_spacing != -1 ? dial_text_line_spacing : 36;
					#region Actual Text
						var tx_x = AUTO_ASTERISK ? xx_ + 28 : xx_, wrapcalc = dial_auto_wrap ? ( 590 - xx_ ) : -1;
						var align_ = scribble_alignment(dial_text_halign, dial_text_valign);
						var scrib_dial = scribble(dial_text) //Dialogue Text
							dial_text_page_c = scrib_dial.get_page_count();
							dial_text_page = clamp(dial_text_page, 0, dial_text_page_c - 1);
							scrib_dial.starting_format(dial_font, dial_text_c).scale(dial_text_scale).outline(dial_text_outline).shadow(dial_text_shdw_clr, dial_text_shdw)
							.allow_line_data_getter().allow_glyph_data_getter().right_to_left(dial_rtl).gradient(dial_gradient_clr, dial_gradient)
							.line_spacing(line_sp).page(dial_text_page).wrap(wrapcalc, dial_auto_page ? 110 : -1).align(align_.h, align_.v)
							
							#region Effects with Regions
								var regions_ = scrib_dial.region_get_bboxes(), regions_len = array_length(regions_), regions_i = 0;
								if ( regions_len > 0 ) { //Found some regions?
									if ( mouse_pressed_right ) { show_debug_message(regions_); }
									repeat ( regions_len ) { //Loop through all regions
										var cur_ = regions_[regions_i]; //Get current region
										switch ( cur_.name ) {
											case "highlight": case "hl": {
												var chr_ = scrib_dial.get_glyph_data(cur_.start_glyph, dial_text_page), myx_ = ( tx_x + dial_text_xoff ) + chr_.left, myy_ = ( yy_ + dial_text_yoff ) + chr_.top; //First, get the starting position of what started the region
												var bbox_ = cur_.bbox_array[0], x_ = bbox_.x1, x_ = bbox_.y1, w_ = ( bbox_.x2 - bbox_.x1 ), h_ = ( bbox_.y2 - bbox_.y1 ); //Then, calculate bbox
												
												if ( !record.enabled || ( record.enabled && typist.get_position() > cur_.start_glyph ) ) { draw_sprite_stretched_ext(spr_pixel, 0, myx_, myy_, w_, h_, dial_highlight, 1); }
												//if ( mouse_pressed_right ) { show_debug_message(cur_.bbox_array[0].x1); }
											} break;
											
											case "underline": case "ul": {
												var chr_ = scrib_dial.get_glyph_data(cur_.start_glyph, dial_text_page), myx_ = ( tx_x + dial_text_xoff ) + chr_.left, myy_ = ( yy_ + dial_text_yoff ) + chr_.bottom; //First, get the starting position of what started the region
												var bbox_ = cur_.bbox_array[0], x_ = bbox_.x1, x_ = bbox_.y1, w_ = ( bbox_.x2 - bbox_.x1 ), h_ = 2; //Then, calculate bbox
											
												if ( !record.enabled || ( record.enabled && typist.get_position() > cur_.start_glyph ) ) { draw_sprite_stretched_ext(spr_pixel, 0, myx_, myy_, w_, h_, dial_underline, 1); }
											} break;
											
											case "strike": case "stk": {
												var chr_ = scrib_dial.get_glyph_data(cur_.start_glyph, dial_text_page), myx_ = ( tx_x + dial_text_xoff ) + chr_.left, myy_ = ( ( ( yy_ + dial_text_yoff ) + chr_.bottom ) + ( ( yy_ + dial_text_yoff ) + chr_.top ) )/ 2; //First, get the starting position of what started the region
												var bbox_ = cur_.bbox_array[0], x_ = bbox_.x1, x_ = bbox_.y1, w_ = ( bbox_.x2 - bbox_.x1 ), h_ = 2; //Then, calculate bbox
											
												if ( !record.enabled || ( record.enabled && typist.get_position() > cur_.start_glyph ) ) { draw_sprite_stretched_ext(spr_pixel, 0, myx_, myy_, w_, h_, dial_striket, 1); }
											} break;
										}
										//if ( mouse_pressed_right ) { show_debug_message(); }
									regions_i++; }
								}
							#endregion
							
							scrib_dial.draw(tx_x + dial_text_xoff, yy_ + dial_text_yoff, dial_text_gif ? typist : undefined);
					#endregion

					#region Dialogue Auto Point
						if ( AUTO_ASTERISK ) {
							var lineamt = scrib_dial.get_line_count(dial_text_page);
							var linec = dial_text_gif ? dial_wrap_count : lineamt;
							if ( array_length(dial_miniface) < lineamt ) { dial_miniface[lineamt + 1] = -1; dial_miniface_index[lineamt + 1] = 0; } 
							var i = 0; repeat ( linec ) {
								var lined = scrib_dial.get_line_data(i, dial_text_page), chr_ = chr(scrib_dial.get_glyph_data(lined.glyph_start, dial_text_page).unicode);
								if ( lined.forced_break && ( chr_ != chr(10) && chr_ != chr(0) && chr_ != "" && chr_ != " " ) && ( !dial_text_gif || point_visible ) ) { //Don't show anything if the line only contains an newline literal
									#region Actual Asterisk
										var p_x = xx_ - 4, p_y = yy_ + lined.y;
										if ( dial_text_gif && dial_miniface[i] > 0 ) { draw_sprite_ensure(dial_miniface[i], dial_miniface_index[i], xx_ + dial_text_xoff, ( p_y + 12 ) + dial_text_yoff, dial_text_scale, dial_text_scale, 0, dial_point_clr, 1); }
										else {
											var scrib_point = scribble(dial_point_chr) //Dialogue Point
												.starting_format(dial_font, dial_point_clr).scale(dial_text_scale).outline(dial_text_outline).shadow(dial_text_shdw_clr, dial_text_shdw).gradient(dial_gradient_clr, dial_gradient)
												.allow_line_data_getter()
												scrib_point.draw(p_x + dial_text_xoff, p_y + dial_text_yoff);
										}
									#endregion
								}
							i++; }
						}
					#endregion
				}
				else { //Draw placeholders
					if ( FACE_CURRENT == -1 ) {
						var emptytxt = scribble("[c_dkgray][wheel][scale,3](But nobody came.)")
						.align(fa_left, fa_top)
						.draw(bordx + 200, bordy + 50);
					
						draw_sprite(spr_face_placeholder, 0, bordx + 9, bordy + 8);  //Portrait placeholder
					}
				}
			#endregion

		outlinesoup_end();
	}
#endregion

if ( ui_tab == 0 && ui_visible ) { ui_manage(); } //Menu handler

#region File Dragging
	if ( ui_visible && file_dragging && UI_MESSAGE ) { //Receive signal for file dragging
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
			draw_sprite_stretched_ext(spr_border_dashed, 0, 35, 135, 605 - 35, bord_visible ? 150 : 300, c_cyan, 0.5 + abs(sin(current_time/300)) * 0.5);
			draw_format("center", "center", fnt_speech, c_cyan);
			draw_text(320, bord_visible ? 210 : 290,  "Drag your text document here to copy over its contents!\n(.TXT ONLY)");
		}
	}
#endregion

if ( ui_visible ) { soupy_lui.render(); } //LimeUI
draw_sprite_ext(spr_pixel, 0, 0, 0, 640, 480, 0, c_black, fader); //Black fade overlay

#region Generating Text
	if ( !ui_visible ) { 
		if ( !ui_viewing ) {
			var gen_ = scribble("[rainbow][wave]Generating...!").scale(4).align(fa_center, fa_middle).draw(320, 210); 
			draw_format("center", "center", fnt_determination, c_yellow);
			if ( record.enabled && record.type == 0 ) {
				draw_text(320, 260, $"(Page: {dial_text_page} | Timer: {record.frames}/ {record.framesmax})"); //Show current page and timer
			}
			else { draw_text_transformed(320, 260, $"(Page: {dial_text_page + 1}/ {dial_text_page_c})", 2, 2, 0); } //Show current page and total page count
		
			draw_format("right", , fnt_determination); draw_text(635, 5, $"(Double-press ESC to cancel)"); //Cancel text
		}
		else { 
			if ( blink() ) { var y_ = ( global.pref.sizematters && global.pref.sizematterstop ) ? 430 : 0; draw_sprite_stretched(spr_border_undertale_outlined, 0, 470, 5 + y_, 165, 35); draw_format("right", , fnt_determination); draw_text(625, 15 + y_, $"(Click to go back)"); }
		}
	}
#endregion

//mouse_debug();
//draw_sprite_ensure(get_face("sck", "capn"), current_time/300, 320, 240);
//draw_sprite_ensure(get_face("undyne", "pissed"), current_time/300, 320 + 40, 240);
//draw_sprite_ensure(get_face("sans", "funny"), current_time/300, 320 + 80, 240);