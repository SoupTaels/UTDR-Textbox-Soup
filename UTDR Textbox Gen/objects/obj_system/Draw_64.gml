///@desc Draw Dialogue Things
//live_auto_call_nr

//draw_format("center", "center");

//draw_sprite_ext(spr_reference, 0, 0, 0, 1, 1, 0, c_yellow, 1);
#region UI Borders
	outlinesoup_start();
		draw_sprite_stretched_ext(spr_border_octagon, 0, 10, 20, room_width - 20, room_height - 90, c_white, 0.6); //Back opacity
		draw_sprite_stretched_ext(spr_border_tabs, 2, 10, 280, room_width - 20, room_height - 350, merge_color(c_orange, c_white, 0.5), 1); //Fading Part
		draw_sprite_stretched_ext(spr_border_tabs, 2, 10, 300, room_width - 20, room_height - 370, c_white, 1); //Bottom
		draw_sprite_stretched_ext(spr_border_tabs, 1, 10, 20, room_width - 20, room_height - 220, c_orange, 1); //Top
	outlinesoup_end();
#endregion
	if ( bord_out ) { outlinesoup_start(); }
	#region Dialogue Box
		var xx_ = dial_face == -1 ? 60 : 176, yy_ = 340; //Text X Y
		var dltrn = spr_bord == spr_border_deltarune; //Check if our border is Deltarune
		draw_sprite_stretched_ext(spr_bord, 0, dltrn ? 24 : 32, dltrn ? 312 : 320, dltrn ? 593 : 578, dltrn ? 167 : 152, bord_clr, 1); //Dialogue Box
		if ( dial_face != -1 ) { draw_sprite_ext(dial_face, dial_face_index, 106, 396, 2, 2, 0, dial_face_clr, 1); } //Dialogue Face
	#endregion

	#region Dialogue Text
		if ( dial_text_shdw ) { //Dialogue Text Shadow
			var scrib_dial_shdw = scribble(dial_text) 
			.starting_format(dial_font, c_white)
			.blend(dial_text_shdw_clr, 1)
			.scale(dial_text_scale)
			.wrap(dial_auto_wrap ? 580 - xx_ : -1)
			.draw(dial_point_auto ? ( xx_ + dial_text_shdw_thick ) + 28 : xx_ + dial_text_shdw_thick, yy_ + dial_text_shdw_thick);
		}
		var scrib_dial = scribble(dial_text) //Dialogue Text
		scrib_dial.starting_format(dial_font, c_white);
		scrib_dial.blend(c_white, 1)
		scrib_dial.scale(dial_text_scale);
		scrib_dial.allow_line_data_getter();
		scrib_dial.wrap(dial_auto_wrap ? 580 - xx_ : -1);
		scrib_dial.draw(dial_point_auto ? xx_ + 28 : xx_, yy_);
	#endregion

	#region Dialogue Auto Point
		if ( dial_point_auto ) {
			if ( dial_text_shdw ) { //Dialogue Text Shadow
				var linec = scrib_dial.get_line_count();
				var i = 0; repeat ( linec ) {
					var lined = scrib_dial.get_line_data(i);
					if ( lined.forced_break ) {
						var scrib_point = scribble(dial_point_chr); //Dialogue Point
						scrib_point.starting_format(dial_font, dial_text_shdw_clr);
						scrib_point.scale(dial_text_scale);
						scrib_point.draw(xx_ + dial_text_shdw_thick, ( yy_ + lined.y ) + dial_text_shdw_thick);
					}
				i++; }
			}
			var linec = scrib_dial.get_line_count();
			var i = 0; repeat ( linec ) {
				var lined = scrib_dial.get_line_data(i);
				if ( lined.forced_break ) {
					var scrib_point = scribble(dial_point_chr); //Dialogue Point
					scrib_point.starting_format(dial_font, dial_point_clr);
					scrib_point.scale(dial_text_scale);
					scrib_point.allow_line_data_getter();
					scrib_point.draw(xx_, yy_ + lined.y);
				}
			i++; }
		}
	#endregion
if  ( bord_out ) { outlinesoup_end(); }
#region UI
	var i = 0, count_ = array_length(butt);
	repeat ( count_ ) { 
		butt[i].update();
	
		 var result = butt[i].button.get_bbox(butt[i].data.x, butt[i].data.ystart);
		 var calc_x = centerizer(result.width, count_, 320, 12);
		butt[i].data.x = calc_x[i];
	i++; }
	
	ui_manage();
	
	draw_sprite_ext(spr_pixel, 0, 0, 0, 640, 480, 0, c_black, fader);
#endregion

mouse_debug();
/*draw_sprite_ensure("toriel_happy", current_time/300);
draw_sprite_ensure("sans_wink", current_time/300, 15 + 50, 15);
draw_sprite_ensure("undyne_officerbaffled", current_time/300, 15 + 100, 15);