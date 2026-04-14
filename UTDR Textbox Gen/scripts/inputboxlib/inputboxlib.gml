global.GMIB_DATA = { active: undefined, switch_tick: 0 }
enum GMIB { DEFAULT=0, TO_LOWER=1, TO_UPPER=2, CHR_END=28, CHR_ENTER=29, CHR_NL=30, CHR_DOWN=10 }

function gmib(style_struct=undefined) constructor {
	
	chr_end = chr(GMIB.CHR_END);
	chr_enter = chr(GMIB.CHR_ENTER);
	chr_nl = chr(GMIB.CHR_NL);
	
	style = {
		w: 256, // box width
		h: 110, // box height
		lh: 24, // line height
		text: "", 
		font: -1, 
		padding: { top: 4, bottom: 4, left: 4, right: 4 },
		c_bkg_unfocused:	{ c: c_gray, a: 1 }, 
		c_bkg_focused:		{ c: c_ltgray, a: 1 },
		c_text_unfocused:	{ c: c_black, a: 1 },
		c_text_focused:		{ c: c_black, a: 1 },
		c_selection:		{ c: c_blue, a: 0.275 },
		char_limit: infinity,
		letter_case: GMIB.DEFAULT,
		min_chw: 0,
		stoppers: " .,()[]{}<>?|:\\+-*/=" + chr_enter,
		textscalex: 1,
		textscaley: 1,
		textscalefactor: 1,
		cursor_spd: 0,
		cursor_blinks: true,
	}

	l_lines = ds_list_create();
	l_chars = ds_list_create();
	l_lines[| 0] = [0,0,0,""];
	l_chars[| 0] = [chr_end, 0];
	
	mx = 0;
	my = 0;
	atx = 0;
	aty = 0;
	tf_lnum = 1;
	
	pad_atx = 0;
	pad_aty = 0;
	pad_w = 0;
	pad_h = 0;
	
	cursor1 = { pos: 0, line: l_lines[| 0], cx: 0, cy: 0, cxs: 0 };
	cursor2 = { pos: 0, line: l_lines[| 0], cx: 0, cy: 0, cxs: 0 };
	
	has_focus = false;
	gamespd = 0;
	cursor_tick = 0;
	cursor_visible = true;
	spam_tick = 0;
	spam_time = infinity;
	spam_now = false;
	clear = false;
	click_tick = 0;
	double_clicked = false;
	last_click_pos = 0;
	
	next_ib = undefined;
	previous_ib = undefined;
	switch_to = undefined;
	
	self.update_style(style_struct);
	
	static set_next = function(ib) {
		next_ib = ib;
	}
	
	static destroy = function() {
		ds_free(l_lines, ds_type_list, function() { show_debug_message("Input box lines list cleared!"); });
		ds_free(l_chars, ds_type_list, function() { show_debug_message("Input box characters list cleared!"); });
	}
	
	static set_previous = function(ib) {
		previous_ib = ib;
	}
	
	static focus = function() {
		global.GMIB_DATA.active = self;
		return self;
	}
	
	static unfocus = function() {
		global.GMIB_DATA.active = undefined;
	}
	
	static update_style = function(style_struct=undefined, update_lines=false, update_chars=false) {
		
		var keys = [];
		if style_struct != undefined {
			keys = variable_struct_get_names(style_struct);
			for(var i = 0, len = array_length(keys); i < len; i++) {
				var key = keys[i];
				style[$ key] = style_struct[$ key];
				
				switch(key) {
					case "w":
					case "h":
					case "lh":
					case "font":
					case "char_limit":
					case "padding":
					case "text":
					case "textscalex":
					case "textscaley":
					case "textscalefactor":
						update_lines = true;
						break;
					case "min_chw":
					case "letter_case":
						update_chars = true;
						break;
				}
			}
		}
		
		pad_atx = atx + style.padding.left;
		pad_aty = aty + style.padding.top;
		pad_w = style.w - style.padding.right - style.padding.left;
		pad_h = style.h - style.padding.top - style.padding.bottom;
		
		var prevfont = draw_get_font();
		draw_set_font(style.font);
		
		if update_chars {
			for(var i = 0, s = ds_list_size(l_chars); i < s; i++) {
				var ch = l_chars[| i][0];
				if !(ch == chr_enter or ch == chr_end or ch == chr_nl) {
					if style.letter_case == GMIB.TO_LOWER ch = string_lower(ch);
					else if style.letter_case == GMIB.TO_UPPER ch = string_upper(ch);
					l_chars[| i][0] = ch;
					l_chars[| i][1] = max(string_width(ch), style.min_chw);
				}
			}
		}
		
		if update_lines or update_chars {
			if array_contains(keys, "text") self.set_text(style.text);
			else {
				while(!self.fit_lines()) {
					ds_list_delete(l_chars, --cursor1.pos);
					if l_chars[| cursor1.pos-1][0] == chr_nl ds_list_delete(l_chars, --cursor1.pos);
				}
				self.update_cursor(cursor1, true);
				self.update_cursor(cursor2, true);
			}
		}
		
		draw_set_font(prevfont);
	}
	
	static copy_cursor_info = function(from, to) {
		
		to.pos = from.pos;
		to.line = [from.line[0], from.line[1], from.line[2], from.line[3]];
		to.rel_pos = from.rel_pos;
		to.cx = from.cx;
		to.cy = from.cy;
		to.cxs = from.cxs;
	}
	
	static fit_lines = function(cposfrom1=cursor1.pos, cposfrom2=cursor2.pos) {
		
		var li = 0;
		var wid = 0;
		var off = 0;
		var pos = 0;
		var char = 0;
		var ch = "";
		var chw = 0;
		var fit_ok = true;
		
		ds_list_clear(l_lines);
		l_lines[| li] = [li, pos, pos, ""];
		var line = l_lines[| li];
		
		for(var i = 0; i < ds_list_size(l_chars); i++) {
			char = l_chars[| i];
			ch = char[0];
			chw = char[1];

			wid += chw;
			
			var nl = wid >= pad_w;
			var enter = ch == chr_enter;
			if nl {
				ds_list_insert(l_chars, i++, [chr_nl, 0]);
				line[2] = pos++;
				if pos > cposfrom1 and pos <= cursor1.pos cursor1.pos++;
				if pos > cposfrom2 and pos <= cursor2.pos cursor2.pos++;
				//line[3] += chr_nl;
			}
			else if ch == chr_nl {
				ds_list_delete(l_chars, i--);
				line[2]++;
				continue;
			}
			if enter {
				line[2] = pos++;
				//line[3] += ch;
			}
			if nl or enter {
				fit_ok = (++li < tf_lnum);
				l_lines[| li] = [li, pos, pos, ""];
				line = l_lines[| li];
				wid = chw;
			}
			if !enter {
				line[2] = pos++;
				if ch != chr_end line[3] += ch;
			}
		}
		
		if ch != chr_end ds_list_add(l_chars, [chr_end, 0]);
		
		return fit_ok;
	}

	static insert = function(txt) {
		txt = string_replace_all(txt, chr(9), "");
		
		if style.letter_case == GMIB.TO_LOWER txt = string_lower(txt);
		else if style.letter_case == GMIB.TO_UPPER txt = string_upper(txt);
		
		var prevfont = draw_get_font();
		draw_set_font(style.font);
		
		tf_lnum = max(1, pad_h div style.lh);
		if cursor1.pos != cursor2.pos self.del();
		
		var len = string_length(txt);
		var cposfrom = cursor1.pos;
		var ch = "";
		var chw = 0;
		
		for(var i = 0; i < len; i++) {
			ch = string_char_at(txt, i+1);
			chw = (ch == chr_enter or ch == chr_end or ch == chr_nl ? 0 : max(string_width(ch), style.min_chw));
			ds_list_insert(l_chars, cursor1.pos++, [ch, chw]);
		}
		
		while(!self.fit_lines(cposfrom) or ds_list_size(l_chars) > style.char_limit) {
			ds_list_delete(l_chars, --cursor1.pos);
			if l_chars[| cursor1.pos-1][0] == chr_nl ds_list_delete(l_chars, --cursor1.pos);
			cposfrom = cursor1.pos;
		}
		
		self.update_cursor(cursor1, true, cursor2);
		
		draw_set_font(prevfont);
	}
	
	static shorten_list = function(list, to) {
		
		var temp_list = ds_list_create();
		for(var i = 0; i < to; i++) temp_list[| i] = ds_list_find_value(list, i);
		ds_list_clear(list);
		ds_list_copy(list, temp_list);
		ds_list_destroy(temp_list);
	}
	
	static update_cursor = function(curs, save_cx=false, copy_to=undefined) {
		
		curs.pos = clamp(curs.pos, 0, ds_list_size(l_chars)-1);
		curs.info = self.get_line(curs.pos); // [line, rel_pos]
		curs.line = curs.info[0];
		curs.rel_pos = curs.info[1];
		curs.cx = self.get_range_width(curs.line[1], curs.line[1] + curs.rel_pos);
		curs.cy = ( curs.line[0] * style.lh );
		
		if save_cx curs.cxs = curs.cx;
		if copy_to != undefined copy_cursor_info(curs, copy_to);
		
		cursor_tick = 0;
		cursor_visible = true;
	}
	
	static get_range_width = function(from, to) {
		
		var wid = 0;
		for(var i = from; i < to; i++) wid += l_chars[| i][1];
		return wid;
	}
	
	static get_nearest_rel_pos_by_x = function(curs, target_x, line) {
		
		var closest = infinity;
		var pos = -1;
		var wid = 0;
		for(var i = line[1]; i < line[2]; i++) {
			if abs(target_x - wid) < closest {
				closest = abs(target_x - wid);
				pos++;
			}
			else break;
			wid += l_chars[| i][1];
		}
		return pos + (abs(target_x - wid) < closest ? 1 : 0);
	}
	
	static get_line = function(pos) {
		
		for(var i = 0, s = ds_list_size(l_lines); i < s; i++) {
			var line = l_lines[| i];
			var from = line[1];
			var to = line[2];
			if clamp(pos, from, to) == pos return [line, pos - from];
		}
		return [l_lines[| 0], 0];
	}
	
	static cursor_to_mouse = function(curs, mousex = mx, mousey = my) {
		
		var line = l_lines[| clamp((mousey - pad_aty) div style.lh, 0, ds_list_size(l_lines)-1)];
		curs.pos = line[1] + self.get_nearest_rel_pos_by_x(curs, max(0, ( mousex - pad_atx ) / style.textscalefactor), line);
		last_right = curs.pos == line[1] ? -1 : 1;
		update_cursor(curs, true);
	}
	
	static move_cursor = function(curs, r=0, d=0, ctrl=false) {
		
		if r != 0 {
			if !ctrl curs.pos = clamp(curs.pos + r, 0, ds_list_size(l_chars));
			else {
				var prevpos = curs.pos;
				self.expand_selection(r, style.stoppers, curs);
				if curs.pos == prevpos curs.pos = clamp(curs.pos + r, 0, ds_list_size(l_chars))
			}
			self.update_cursor(curs, true);
		}
		
		if d != 0 {
			var nextl = curs.line[0] + d;
			if nextl == clamp(nextl, 0, ds_list_size(l_lines)-1) {
				var line = l_lines[| nextl];
				curs.pos = line[1] + self.get_nearest_rel_pos_by_x(curs, curs.cxs, line);
				self.update_cursor(curs);
			}
		}
		
		if !keyboard_check(vk_shift) copy_cursor_info(cursor1, cursor2);
	}
	
	static expand_selection = function(right, stoppers=style.stoppers, curs=undefined) {
		
		if curs == undefined {
			if right {
				var s = ds_list_size(l_chars)-1;
				while(cursor1.pos++ < s) if string_pos(l_chars[| cursor1.pos][0], style.stoppers) break;
			}
			else {
				while(cursor2.pos-- > 0) if string_pos(l_chars[| cursor2.pos][0], style.stoppers) break;
			}
		}
		else if right {
			var s = ds_list_size(l_chars)-1;
			while(curs.pos++ < s) if string_pos(l_chars[| curs.pos][0], style.stoppers) break;
		}
		else {
			while(curs.pos-- > 0) if string_pos(l_chars[| curs.pos][0], style.stoppers) break;
		}
	}
	
	static selection_draw = function() {
		
		draw_set_color(style.c_selection.c);
		draw_set_alpha(style.c_selection.a);
		if cursor1.line[0] == cursor2.line[0] {
			draw_rectangle(pad_atx + cursor1.cx * style.textscalefactor, pad_aty + cursor1.cy * style.textscalefactor, pad_atx + cursor2.cx * style.textscalefactor, pad_aty + cursor2.cy + style.lh - 1 * style.textscalefactor, false);
		}
		else {
			var upper = cursor1.pos < cursor2.pos ? cursor1 : cursor2;
			var lower = cursor1.pos < cursor2.pos ? cursor2 : cursor1;
			draw_rectangle(pad_atx + upper.cx * style.textscalefactor, pad_aty + upper.cy * style.textscalefactor, pad_atx + get_range_width(upper.line[1], upper.line[2]) * style.textscalefactor, pad_aty + upper.cy + style.lh - 1 * style.textscalefactor, false);
			draw_rectangle(pad_atx * style.textscalefactor, pad_aty + lower.cy * style.textscalefactor, pad_atx + get_range_width(lower.line[1], lower.pos) * style.textscalefactor, pad_aty + lower.cy + style.lh - 1 * style.textscalefactor, false);
			for(var i = upper.line[0]+1; i < lower.line[0]; i++) {
				var line = l_lines[| i];
				draw_rectangle(pad_atx * style.textscalefactor, pad_aty + i * style.lh * style.textscalefactor, pad_atx + get_range_width(line[1], line[2]) * style.textscalefactor, pad_aty + i * style.lh + style.lh - 1 * style.textscalefactor, false);
			}
		}
		draw_set_alpha(1);
	}

	static del = function(backspace=true, ctrl=false) {
		
		var len = max(1, abs(cursor1.pos - cursor2.pos));
		
		if backspace or cursor1.pos != cursor2.pos {
			if cursor1.pos < cursor2.pos {
				repeat(len) ds_list_delete(l_chars, --cursor2.pos);
				cursor1.pos = cursor2.pos;
			}
			else {
				repeat(len) ds_list_delete(l_chars, --cursor1.pos);
			}
		}
		else repeat(len) {
			if cursor1.pos+1 < ds_list_size(l_chars) ds_list_delete(l_chars, cursor1.pos);
		}
		
		if ctrl {
			self.expand_selection(!backspace);
			self.del();
		}
		
		self.fit_lines();
		self.update_cursor(cursor1, true, cursor2);
	}
	
	static set_text = function(txt) {
		
		ds_list_clear(l_chars);
		l_chars[| 0] = [chr_end, 0];
		cursor1.pos = 0;
		cursor2.pos = 0;
		self.insert(txt);
	}
	
	static get_text = function(keep_enters=false) {
		
		if ( !ds_exists(l_chars, ds_type_list) ) { exit; }
		var pos = 0;
		var to = ds_list_size(l_chars);
		var str = @"";
		
		while(pos < to-1) str += l_chars[| pos++][0];
		
		str = string_replace_all(str, chr_end, "");
		if !keep_enters str = string_replace_all(str, chr_enter, "\n");
		str = string_replace_all(str, chr_nl, "");
		return str;
	}
	
	static copy = function(keep_enters=true) {
		
		var pos = min(cursor1.pos, cursor2.pos);
		var to = max(cursor1.pos, cursor2.pos);
		var str = keep_enters ? @"" : "";
				
		while(pos < to) str += l_chars[| pos++][0];
				
		str = string_replace_all(str, chr_end, "");
		str = string_replace_all(str, chr_enter, "\n");
		str = string_replace_all(str, chr_nl, "");
		clipboard_set_text(str);
	}
	
	static paste = function() {
		
		if clipboard_has_text() {
			self.insert(string_replace_all(clipboard_get_text(), "\n", chr_enter));
		}
	}
	
	static cut = function() {
		
		self.copy();
		self.del();
	}
	
	static draw = function(x, y, gui_ev=true) {
		
		atx = x;
		aty = y;
		pad_atx = atx + style.padding.left;
		pad_aty = aty + style.padding.top;
		pad_w = ceil(( ( style.w - style.padding.right ) - style.padding.left )/ style.textscalefactor);
		pad_h = ceil(( ( style.h - style.padding.top ) - style.padding.bottom )/ style.textscalefactor);
		
		gamespd = game_get_speed(gamespeed_fps);
		
		mx = gui_ev ? mouse_x_gui : mouse_x;
		my = gui_ev ? mouse_y_gui : mouse_y;
		
		has_focus = global.GMIB_DATA.active == self;
		
		if !has_focus clear = false;
		else {
			global.GMIB_DATA.switch_tick = max(0, --global.GMIB_DATA.switch_tick);
			
			if !clear {
				clear = true;
				keyboard_string = "";
				cursor_tick = 0;
				cursor_visible = true;
			}
			
			double_clicked = false;
			click_tick = max(0, --click_tick);
			if ( mouse_released ) {
				if click_tick > 0 and last_click_pos == cursor1.pos {
					double_clicked = true;
					click_tick = 0;
				}
				else {
					click_tick = gamespd * 0.5;
					last_click_pos = cursor1.pos;
				}
			}
			
			if ++cursor_tick >= gamespd * 0.5 {
				cursor_tick = 0;
				if ( style.cursor_blinks ) { cursor_visible = !cursor_visible; }
			}
			
			spam_now = false;
			if keyboard_check_pressed(vk_anykey) {
				spam_time = gamespd * 0.5;
				spam_tick = 0;
			}
			else if keyboard_check(vk_anykey) {
				if ++spam_tick > spam_time {
					spam_tick = 0;
					spam_time = gamespd * 0.03;
					spam_now = true;
				}
			}
			
			if double_clicked {
				self.expand_selection(true);
				self.expand_selection(false);
				self.update_cursor(cursor1, true);
				self.update_cursor(cursor2);
			}
		
			if keyboard_check_released(vk_anykey) and !keyboard_check(vk_anykey) {
				keyboard_string = "";
			}
		
			if keyboard_check_pressed(vk_anykey) or spam_now {
			
				switch(keyboard_key) {
					case vk_left:
						self.move_cursor(cursor1, -1, 0, keyboard_check(vk_control));
						break;
					case vk_right:
						self.move_cursor(cursor1, 1, 0, keyboard_check(vk_control));
						break;
					case vk_up:
						self.move_cursor(cursor1, 0, -1);
						break;
					case vk_down:
						self.move_cursor(cursor1, 0, 1);
						break;
					case vk_enter:
						keyboard_string += chr_enter;
						break;
					case vk_tab:
						keyboard_string = "";
						if global.GMIB_DATA.switch_tick == 0 {
							if keyboard_check(vk_shift) {
								if !is_undefined(previous_ib) {
									previous_ib.focus();
									global.GMIB_DATA.switch_tick = 2;
								}
							}
							else {
								if !is_undefined(next_ib) {
									next_ib.focus();
									global.GMIB_DATA.switch_tick = 2;
								}
							}
						}
						break;
					case vk_backspace:
						self.del(true, keyboard_check(vk_control));
						break;
					case vk_delete:
						self.del(false, keyboard_check(vk_control));
						break;
				}
			}
		
			if keyboard_check(vk_anykey) {
				
				if keyboard_check(vk_control) {
					if keyboard_check_pressed(ord("C")) and cursor1.pos != cursor2.pos {
						keyboard_string = "";
						self.copy();
					}
					else if keyboard_check_pressed(ord("V")) or (keyboard_check(ord("V")) and spam_now) {
						keyboard_string = "";
						self.paste();
					}
					else if keyboard_check_pressed(ord("X")) and cursor1.pos != cursor2.pos {
						keyboard_string = "";
						self.cut();
					}
					else if keyboard_check_pressed(ord("A")) {
						keyboard_string = "";
						cursor2.pos = 0;
						cursor1.pos = ds_list_size(l_chars);
						self.update_cursor(cursor1, true);
						self.update_cursor(cursor2);
					}
					else if keyboard_check_pressed(vk_backspace) {
						keyboard_string = "";
					}
				}
			
				if string_length(keyboard_string) != 0 {
					self.insert(keyboard_string);
					keyboard_string = "";
				}
			}
		}
		
		var prevdraw = [draw_get_font(), draw_get_color(), draw_get_alpha()];
		draw_set_font(style.font);
		
		draw_set_color(has_focus ? style.c_bkg_focused.c : style.c_bkg_unfocused.c);
		draw_set_alpha(has_focus ? style.c_bkg_focused.a : style.c_bkg_unfocused.a);
		draw_rectangle(atx, aty, atx + style.w, aty + style.h, false);
		
		if has_focus and cursor1.pos != cursor2.pos self.selection_draw();
		
		draw_set_color(has_focus ? style.c_text_focused.c : style.c_text_unfocused.c);
		draw_set_alpha(has_focus ? style.c_text_focused.a : style.c_text_unfocused.a);
		
		draw_set_valign(fa_bottom);
		if style.min_chw == 0 {
			draw_set_halign(fa_left);
			for ( var i = 0, s = ds_list_size(l_lines); i < s; i++; ) {
				draw_text_transformed(pad_atx, pad_aty + i * style.lh + style.lh, l_lines[| i][3], style.textscalex * style.textscalefactor, style.textscaley * style.textscalefactor, 0);
			}
		}
		else {
			draw_set_halign(fa_center);
			var wid = 0;
			for(var i = 0, s = ds_list_size(l_lines); i < s; i++) {
				var line = l_lines[| i];
				for(var pos = line[1]; pos < line[2]; pos++) {
					var char = l_chars[| pos];
					var chw = char[1];
					draw_text_transformed(pad_atx + wid + (chw div 2), pad_aty + i * style.lh + style.lh, char[0], style.textscalex * style.textscalefactor, style.textscaley * style.textscalefactor, 0);
					wid += chw;
				}
				wid = 0;
			}
		}
		draw_set_valign(fa_top);
		draw_set_halign(fa_left);
		
		if ( has_focus && cursor_visible ) { var cursor_alpha = abs(sin(current_time/style.cursor_spd)); draw_sprite_ext(spr_pixel, 0, pad_atx + cursor1.cx * style.textscalefactor, pad_aty + cursor1.cy, 2, style.lh, 0, c_white, style.cursor_blinks ? 1 : cursor_alpha); }
		
		draw_set_font(prevdraw[0]);
		draw_set_color(prevdraw[1]);
		draw_set_alpha(prevdraw[2]);
		
		if ( mouse_pressed ) {
			if ( point_in_rectangle(mx, my, atx, aty, atx + style.w, aty + style.h) ) { self.focus(); } else if ( has_focus ) { self.unfocus(); }
			
			self.cursor_to_mouse(cursor2);
			self.copy_cursor_info(cursor2, cursor1);
		}
		else if ( mouse_check ) { self.cursor_to_mouse(cursor1); }
	}
}