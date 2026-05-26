///@desc Init
//if ( live_call() ) { return live_result; } 

#region Loading Preferences
	if ( file_exists(PREF_SOUP) ) {
		var buff_ = buffer_load(PREF_SOUP), data_ = buffer_read(buff_, buffer_text), pref_ = undefined;
		buffer_delete(buff_);
		try { pref_ = json_parse(data_); } catch(err_) { show_debug_message(err_.message); }
	
		if ( is_struct(pref_) ) {
			var get_ = pref_[$ "firsttime"]; global.pref.firsttime = !is_undefined(get_) ? get_ : true;
			var get_ = pref_[$ "shadowoff"]; global.pref.shadowoff = !is_undefined(get_) ? abs(round(get_)) : 1;
			var get_ = pref_[$ "killaudio"]; global.pref.killaudio = !is_undefined(get_) ? get_ : false;
			var get_ = pref_[$ "sizematters"]; global.pref.sizematters = !is_undefined(get_) ? get_ : false;
			var get_ = pref_[$ "sizematterstop"]; global.pref.sizematterstop = !is_undefined(get_) ? get_ : false;
			var get_ = pref_[$ "hidemessages"]; global.pref.hidemessages = !is_undefined(get_) ? get_ : false;
			var get_ = pref_[$ "checkupdates"]; global.pref.checkupdates = !is_undefined(get_) ? get_ : true;
		}
	}
	
	#region Http.gml
		http_active = false;
		http_requests = ds_map_create();
	#endregion
#endregion

#region Dialogue Box
	outlinesoup_init(, , , , 2); soupyclipm_init(); display_set_gui_size(640, 480);
	spr_bord = spr_border_undertale; //Border Sprite
	bord_name = "spr_border_undertale"; //Border internal name
	bord_clr = c_white; //Border Color
	bord_out = true; //Whether border should have an outline
	bord_prev = spr_bord; //Previous border
	bord_visible = true; //Whether the dialogue box and text is visible
	bord_box_visible = true; //Whether the dialogue box is visible
	bord_index = 0; //Border image index
	bord_spd = 0; //Border image speed
	bord_anim = true; //Animation type ( 0 - Start over, 1 - Bounce back )
	bord_anim_track = 0;
	bord_scale = 2; //Border sprite scale
	bord_stretch = false; //Whether the nineslice border should stretch or tile
	bord_xoff = 0; //Arb Border X off
	bord_yoff = 0; //Arb Border Y off
	bord_angle = 0; //Arb Border Angle
#endregion

#region Dialogue Text
	#region Adjust Fonts
		var i = 0, arr = tag_get_assets("fonts"), len = array_length(arr);
		repeat (  len ) {
			var cur_ = arr[i];
			scribble_font_bake_outline_and_shadow(cur_, $"{cur_}_s", global.pref.shadowoff, global.pref.shadowoff, SCRIBBLE_OUTLINE.NO_OUTLINE, 0, false);
			scribble_font_bake_outline_and_shadow(cur_, $"{cur_}_outline", global.pref.shadowoff, global.pref.shadowoff, SCRIBBLE_OUTLINE.EIGHT_DIR, 0, false);
			var h_ = scribble_glyph_get($"{cur_}_s", "W", SCRIBBLE_GLYPH.FONT_HEIGHT), x_ = scribble_glyph_get($"{cur_}_s", "A", SCRIBBLE_GLYPH.LEFT_OFFSET);
			scribble_glyph_set($"{cur_}_outline", all, SCRIBBLE_GLYPH.FONT_HEIGHT, h_); scribble_glyph_set($"{cur_}_outline", all, SCRIBBLE_GLYPH.LEFT_OFFSET, x_);
			scribble_font_delete(cur_); scribble_font_rename($"{cur_}_s", cur_);
		i++; }
	
		scribble_glyph_set("fnt_sans", all, SCRIBBLE_GLYPH.Y_OFFSET, 1); scribble_glyph_set("fnt_sans", all, SCRIBBLE_GLYPH.FONT_HEIGHT, 14);
		scribble_glyph_set("fnt_sans_outline", all, SCRIBBLE_GLYPH.Y_OFFSET, 0); scribble_glyph_set("fnt_sans_outline", all, SCRIBBLE_GLYPH.FONT_HEIGHT, 14);
		scribble_glyph_set("fnt_papyrus", all, SCRIBBLE_GLYPH.Y_OFFSET, -1); scribble_glyph_set("fnt_papyrus", all, SCRIBBLE_GLYPH.FONT_HEIGHT, 14);
		scribble_glyph_set("fnt_papyrus_outline", all, SCRIBBLE_GLYPH.Y_OFFSET, -2); scribble_glyph_set("fnt_papyrus_outline", all, SCRIBBLE_GLYPH.FONT_HEIGHT, 14);
		scribble_glyph_set("fnt_determination", all, SCRIBBLE_GLYPH.X_OFFSET, 0); scribble_glyph_set("fnt_determination", "!", SCRIBBLE_GLYPH.X_OFFSET, 1);
		scribble_glyph_set("fnt_determination_outline", all, SCRIBBLE_GLYPH.X_OFFSET, -1); scribble_glyph_set("fnt_determination_outline", "!", SCRIBBLE_GLYPH.X_OFFSET, 0);
		//I'm so happy Deltarune doesn't introduce new fonts cause fuck this honestly. Never want to do this again.
	#endregion
	
	dial_text = ""; //Dialogue Text
	dial_font = "fnt_determination"; //Dialogue Font
	dial_text_scale = 2; //Text Scale
	dial_text_c = c_white; //Text Color
	dial_text_gif = false; //Whether to enable typewriting
	dial_updatet = 0; //Dialogue update timer
	dial_updatet_max = 45; //Dialogue update timer delay
	dial_text_outline = c_black; //Dialogue Outline Color
	dial_point_auto = false; //Whether to automatically add points
	dial_point_chr = "*"; //Dialogue Point Character
	dial_point_clr = c_white; dial_point_clr_anim = c_white; dial_point_clr_anim_alpha = 0; //Dialogue Point Clr and flash color
	dial_auto_wrap = true; //Whether to automatically wrap dialogue to new lines
	dial_wrap_count = 1; //Current wrapped line
	dial_text_page = 0; //Current page
	dial_text_page_c = 0; //Amount of pages in a dialogue sequence
	dial_text_line_spacing = -1; //Spacing between lines. -1 for auto.
	point_visible = false; //Whether the auto-points are visible
	dial_text_xoff = 0; //Offset X Text
	dial_text_yoff = 0; //Offset Y Text
	dial_text_halign = 0; //Text H alignment
	dial_text_valign = 0; //Text V alignment
	dial_auto_page = false; //Whether to automatically add new pages when text height overflows
	dial_rtl = false; //Right-to-left text
	dial_gradient = false; //Text gradient
	dial_gradient_orig = dial_gradient; //Text gradient original
	dial_gradient_clr = c_white; //Text gradient color
	dial_gradient_clr_orig = dial_gradient_clr; //Text original gradient color
	dial_indicator = -1; //Dialogue ended indicator
	dial_indicator_index = 0;
	dial_indicator_spd = 0; 
	dial_indicator_anim = 0; dial_indicator_anim_track = 0;
	dial_indicator_visible = false; dial_indicator_scale = 1; dial_indicator_xoff = 0; dial_indicator_yoff = 0; dial_indicator_angle = 0; dial_indicator_blink = 300;
	
	#region Typist
		typist = scribble_typist(); //Dialogue Engine
		typist_spd = 0.5; //Typewriter speed
		typist_spd_orig = typist_spd; //Typewriter original speed
		typist_smooth = 0; //Typewriter smooth
		typist.in(typist_spd, typist_smooth);
		typist.function_per_char(function(_element, _position, _typist) { //Function to run per character
			#region Auto Asterisks
				var mychr = chr(_element.get_glyph_data(_position - 1).unicode); //Get the currently revealed character
				var mychr2 = chr(_element.get_glyph_data(_position).unicode); //Get the next character
				if ( mychr == chr(10) && string_lettersdigits(mychr2) != "" ) { //Newline
					var lined = _element.get_line_data(dial_wrap_count, dial_text_page);
					if ( !lined.forced_break ) { dial_wrap_count++; } //Account for cases where there's a line wrap and a break
					dial_wrap_count++;
				}
				if ( !point_visible && mychr2 != "" ) { point_visible = true; }
			#endregion
		
			#region Animate Face
				if ( ( FACE_USING && dial_face_auto ) && string_lettersdigits(mychr) != "" ) { //Animate the face while dialogue is typing out. Only animate if there's letters and numbers being said
					static anim_timer = 0; anim_timer++;
					if ( anim_timer > dial_face_anim ) { anim_timer = 0; FACE_INDEX++; }
				}
			#endregion
		});
		typist.function_on_complete(function() { //Function to run once the dialogue is complete
			dial_indicator_visible = true;
			if ( dial_face_auto ) { FACE_INDEX = 0; }
			if ( !dial_face_keep ) { FACE_CURRENT = FACE_ORIGINAL; } //Switch back to the original face
			typist_spd = typist_spd_orig; //Switch back to the original typewriter speed
			
			if ( !instance_exists(obj_mini) ) { exit; }
			with ( obj_mini ) { if ( page == other.dial_text_page ) { active = true; TweenFire("$13", $"~{smooth ? "oquad" : "linear"}", "xoff", 30, 0, "alpha", 0, 1); } } 
		});
		
		typist_reset = function () { dial_indicator_visible = false; dial_gradient = dial_gradient_orig; dial_gradient_clr = dial_gradient_clr_orig; dial_face_angle = dial_face_angle_orig; dial_face_alpha = dial_face_alpha_orig; dial_face_xoff = 0; dial_face_yoff = 0; dial_face_xscale_off = 0; dial_face_yscale_off = 0; } //Function to reset portrait modifications after dialogue finishes
		
		#region Ease Builder
			typist_ease = { type: SCRIBBLE_EASE.LINEAR, x: 0, y: 0, xscale: 1, yscale: 1, angle: 0, alpha: 1, };
			typist.ease(typist_ease.type, typist_ease.x, typist_ease.y, typist_ease.xscale, typist_ease.yscale, typist_ease.angle, typist_ease.alpha);
		#endregion
	#endregion
	
	#region Typist Events
		#region Dialogue Settings
			scribble_typists_add_event("face", function(_, param) { //Switch to a new portrait sprite
				FACE_PREVIOUS = FACE_CURRENT; //Get the previous face
				FACE_CURRENT = get_face(param[0], array_length(param) > 1 ? param[1] : -1);
				if ( FACE_USING ) { FACE_INTERNAL = param[0]; }
				FACE_INDEX = array_length(param) > 2 && real_ext(param[2]) != "" ? real_ext(param[2]) : ( array_length(param) > 3 && real_ext(param[3]) != "" && bool(real_ext(param[3])) ? sprite_get_number(FACE_CURRENT) - 1 : 0 );
			});
			scribble_typists_add_event("face_orig", function(_, param) { //Change the original previous face to a new 
				FACE_ORIGINAL = get_face(param[0], array_length(param) > 1 ? param[1] : -1);
				FACE_INDEX = array_length(param) > 2 && real_ext(param[2]) != "" ? real_ext(param[2]) : ( array_length(param) > 3 && real_ext(param[3]) != "" && bool(real_ext(param[3])) ? sprite_get_number(FACE_CURRENT) - 1 : 0 );
			});
			scribble_typists_add_event("face_prev", function(_, param) { FACE_CURRENT = FACE_PREVIOUS; }); //Change the face back to the previous face
			scribble_typists_add_event("face_auto", function(_, param) { dial_face_auto = bool(string_letters(param[0])); }); //Switch the automatic animation of the face
			scribble_typists_add_event("gradient", function(_, param) { dial_gradient = bool(string_letters(param[0])); }); //Switch the gradient
			scribble_typists_add_event("face_index", function(_, param) { FACE_INDEX = real(string_digits(param[0])); }); //Change the index of the face(if dial_face_auto is off), for sprites with more sprites and expressions
			scribble_typists_add_event("face_anim", function(_, param) { dial_face_anim = real(string_digits(param[0])); }); //Changes how often the face should animate for every letter revealed
			var func_ = function(_, param) { var value_ = real_ext(param[0]); FACE_SPEED = value_ == "" ? 0 : value_; }
			scribble_typists_add_event("face_speed", func_); scribble_typists_add_event("face_spd", func_); //Change the speed of the face(if dial_face_auto is off), for sprites with more sprites and expressions
			scribble_typists_add_event("border", function(_, param) { //Switch to a new border sprite
				var bord_ = get_border(param[0]);
				spr_bord = bord_ != -1 ? bord_ : spr_border_undertale;
			});
			scribble_typists_add_event("indicator", function(_, param) { //Switch to a new indicator sprite
				var value_ = param[0], face_ = get_face(value_), bord_ = get_border(value_), icon_ = get_icon(value_);
				
				var index_ = ( array_length(param) > 1 && real_ext(param[1]) != "" ? real_ext(param[1]) : 0 );
				var spd_ = ( array_length(param) > 2 && real_ext(param[2]) != "" ? real_ext(param[2]) : 0 );
				var anim_ = ( array_length(param) > 3 && real_ext(param[3]) != "" ? real_ext(param[3]) : 0 );
				if ( face_ == -1 && bord_ == -1 && icon_ == -1 ) { SYSTEMUI.dial_indicator = -1; SYSTEMUI.dial_indicator_index = 0; SYSTEMUI.dial_indicator_spd = 0; SYSTEMUI.dial_indicator_anim = 0; }
				else {
					if ( face_ != -1 ) { SYSTEMUI.dial_indicator = face_; SYSTEMUI.dial_indicator_index = index_; SYSTEMUI.dial_indicator_spd = spd_; SYSTEMUI.dial_indicator_anim = anim_; exit; } 
					if ( bord_ != -1 ) { SYSTEMUI.dial_indicator = bord_; SYSTEMUI.dial_indicator_index = index_; SYSTEMUI.dial_indicator_spd = spd_; SYSTEMUI.dial_indicator_anim = anim_; exit; } 
					if ( icon_ != -1 ) { SYSTEMUI.dial_indicator = icon_; SYSTEMUI.dial_indicator_index = index_; SYSTEMUI.dial_indicator_spd = spd_; SYSTEMUI.dial_indicator_anim = anim_; exit; } 
				}
			});
			var func_ = function(_, param) { var value_ = real_ext(param[0]); bord_spd = value_ == "" ? 0 : value_; } 
			scribble_typists_add_event("border_speed", func_); scribble_typists_add_event("border_spd", func_); //Change the animation speed of borders
			scribble_typists_add_event("finish", function(_, param) { typist.skip(); }); //Finish all the text immediately
			scribble_typists_add_event("skip", function(_, param) { //Skips to the next page, disregarding current dialogue 
				if ( dial_text_page < dial_text_page_c - 1 ) {
					if ( array_length(param) == 0 ) { dial_text_page++; } //No argument provided? Just go to the next page
					else { dial_text_page = real(string_digits(param[0])); dial_text_page = clamp(dial_text_page, 0, dial_text_page_c); } //Go to a specific page
				}
			});
			scribble_typists_add_event("face_stick", function(_, param) { FACE_ORIGINAL = get_face(FACE_INTERNAL); }); //Make the previous dialogue face stick
			scribble_typists_add_event("face_stick_all", function(_, param) { //Make the previous dialogue face stick for all upcoming dialogue
				var i = dial_text_page, face_spr = FACE_CURRENT; 
				repeat ( ( dial_text_page_c ) - i ) { dial_face[i] = face_spr; dial_face_prev[i] = face_spr; dial_face_original[i] = face_spr; dial_face_name[i] = FACE_INTERNAL; i++; }
			});
			scribble_typists_add_event("speed_pop", function(_, param) { typist_spd = typist_spd_orig; }); //Changes the typist speed back to the default
		#endregion
		
		#region Face & Border Effects
			var efxfunc = function(_, param) { //Play an effect
				var len = array_length(param);
				var delayfunc = function () { SYSTEMUI.typist.pause(); TweenScript(SYSTEMUI, 0, 1.01, function () { SYSTEMUI.typist.unpause(); }); }
				switch ( string_lower(string_trim(param[0])) ) {
					case "squash": case "squish": { TweenFire("$15", "~oquad", "dial_face_xscale_off", 0.3, 0, "dial_face_yscale_off", -0.3, 0); delayfunc(); } break; //Squish the face 
					case "squeeze": case "stretch": { TweenFire("$15", "~oquad", "dial_face_xscale_off", -0.3, 0, "dial_face_yscale_off", 0.3, 0); delayfunc(); } break; //Squeeze the face
					case "flash": { //Make the face flash a color [effect,flash,r,g,b,frames]
						var getclr = real_ext(len > 1 ? param[1] : "255"), getclr2 = real_ext(len > 2 ? param[2] : "255"), getclr3 = real_ext(len > 3 ? param[3] : "255"), time_ = real_ext(len > 4 ? param[4] : "15");
						var myclr = make_color_rgb(getclr != "" ? getclr : 255, getclr2 != "" ? getclr2 : 255, getclr3 != "" ? getclr3 : 255); dial_point_clr_anim = myclr;
						TweenFire("?", obj_system, $"${time_ != "" ? time_ : 15}", "~oquad", "dial_point_clr_anim_alpha", 1, 0); delayfunc();
					} break;
					case "color": case "blend": { //Make the face blend to a different [effect,color,r,g,b,frames]
						var getclr = real_ext(len > 1 ? param[1] : "255"), getclr2 = real_ext(len > 2 ? param[2] : "255"), getclr3 = real_ext(len > 3 ? param[3] : "255"), time_ = real_ext(len > 4 ? param[4] : "15");
						var myclr = make_color_rgb(getclr != "" ? getclr : 255, getclr2 != "" ? getclr2 : 255, getclr3 != "" ? getclr3 : 255);
						TweenFire("?", obj_system, $"${time_ != "" ? time_ : 15}", TPCol("dial_face_clr"), dial_face_clr, myclr); delayfunc();
					} break;
					case "colorasterisk": case "blendasterisk": case "coloraster": case "blendaster": { //Make the asterisks blend to a different [effect,color,r,g,b,frames]
						var getclr = real_ext(len > 1 ? param[1] : "255"), getclr2 = real_ext(len > 2 ? param[2] : "255"), getclr3 = real_ext(len > 3 ? param[3] : "255"), time_ = real_ext(len > 4 ? param[4] : "15");
						var myclr = make_color_rgb(getclr != "" ? getclr : 255, getclr2 != "" ? getclr2 : 255, getclr3 != "" ? getclr3 : 255);
						TweenFire("?", obj_system, $"${time_ != "" ? time_ : 15}", TPCol("dial_point_clr"), dial_point_clr, myclr); delayfunc();
					} break;
					case "colorborder": case "blendborder": { //Make the border blend to a different [effect,colorblend,r,g,b,frames]
						var getclr = real_ext(len > 1 ? param[1] : "255"), getclr2 = real_ext(len > 2 ? param[2] : "255"), getclr3 = real_ext(len > 3 ? param[3] : "255"), time_ = real_ext(len > 4 ? param[4] : "15");
						var myclr = make_color_rgb(getclr != "" ? getclr : 255, getclr2 != "" ? getclr2 : 255, getclr3 != "" ? getclr3 : 255);
						TweenFire("?", obj_system, $"${time_ != "" ? time_ : 15}", TPCol("bord_clr"), bord_clr, myclr); delayfunc();
					} break;
					case "colorgrad": case "blendgrad": case "colorgradient": case "blendgradient": { //Make the gradient blend to a different [effect,colorgrad,r,g,b,frames]
						var getclr = real_ext(len > 1 ? param[1] : "255"), getclr2 = real_ext(len > 2 ? param[2] : "255"), getclr3 = real_ext(len > 3 ? param[3] : "255"), time_ = real_ext(len > 4 ? param[4] : "15");
						var myclr = make_color_rgb(getclr != "" ? getclr : 255, getclr2 != "" ? getclr2 : 255, getclr3 != "" ? getclr3 : 255);
						if ( !dial_gradient ) { dial_gradient = true; }
						TweenFire("?", obj_system, $"${time_ != "" ? time_ : 15}", TPCol("dial_gradient_clr"), dial_gradient_clr, myclr); delayfunc();
					} break;
					case "fade": case "ghost": case "opacity": { //Make the face fade out to the specified target number [effect,fade,#,frames]
						var getamt = real_ext(len > 1 ? param[1] : "0"), time_ = real_ext(len > 2 ? param[2] : "30");
						TweenFire("?", obj_system, $"${time_ != "" ? time_ : 30}", "dial_face_alpha>", getamt != "" ? getamt : 0); delayfunc();
					} break;
					case "index": case "frame": case "img": { //Make the face's sprite index go to the specified target number [fx,index,#,frames]
						var getamt = real_ext(len > 1 ? param[1] : sprite_get_number(FACE_CURRENT) - 1), time_ = real_ext(len > 2 ? param[2] : "30");
						TweenFire("?", obj_system, $"${time_ != "" ? time_ : 30}", TPArray(SYSTEMUI.dial_face_index, SYSTEMUI.dial_text_page), FACE_INDEX, getamt == "" ? sprite_get_number(FACE_CURRENT) - 1 : getamt); delayfunc();
					} break;
					case "indexbord": case "framebord": case "imgbord": case "indexborder": case "frameborder": case "imgborder": { //Make the border's sprite index go to the specified target number [fx,indexbord,#,frames]
						var getamt = real_ext(len > 1 ? param[1] : sprite_get_number(spr_bord) - 1), time_ = real_ext(len > 2 ? param[2] : "30");
						TweenFire("?", obj_system, $"${time_ != "" ? time_ : 30}", "bord_index>", getamt == "" ? sprite_get_number(spr_bord) - 1 : getamt); delayfunc();
					} break;
					case "rotate": case "rot": case "angle": { //Make the face rotate to the specified target number [effect,rotate,#,frames,issmooth]
						var getamt = real_ext(len > 1 ? param[1] : "359"), time_ = real_ext(len > 2 ? param[2] : "30"), smooth_ = real_ext(len > 3 ? param[3] : "0"); smooth_ = smooth_ != "" ? bool(smooth_) : false;
						TweenFire("?", obj_system, $"${time_ != "" ? time_ : 30}", $"~{!smooth_? "linear" : "oquad"}", "dial_face_angle>", getamt != "" ? getamt : 0); delayfunc();
					} break;
					case "scale": case "size": { //Make the face scale to the specified target number [effect,scale,#,#,frames,issmooth]
						var getamt = real_ext(len > 1 ? param[1] : "0"), getamt2 = real_ext(len > 2 ? param[2] : "0"), time_ = real_ext(len > 3 ? param[3] : "30"), smooth_ = real_ext(len > 4 ? param[4] : "0"); smooth_ = smooth_ != "" ? bool(smooth_) : false;
						TweenFire("?", obj_system, $"${time_ != "" ? time_ : 30}", $"~{!smooth_? "linear" : "oquad"}", "dial_face_xscale_off>", getamt != "" ? getamt : 0, "dial_face_yscale_off>", getamt2 != "" ? getamt2 : 0); delayfunc();
					} break;
					case "slide": case "move": case "xy": { //Make the face slide to the specified target number [effect,slide,#,#,frames,issmooth]
						var getamt = real_ext(len > 1 ? param[1] : "0"), getamt2 = real_ext(len > 2 ? param[2] : "0"), time_ = real_ext(len > 3 ? param[3] : "30"), smooth_ = real_ext(len > 4 ? param[4] : "0"); smooth_ = smooth_ != "" ? bool(smooth_) : false;
						TweenFire("?", obj_system, $"${time_ != "" ? time_ : 30}", $"~{!smooth_? "linear" : "oquad"}", "dial_face_xoff>", getamt != "" ? getamt : 0, "dial_face_yoff>", getamt2 != "" ? getamt2 : 0); delayfunc();
					} break;
					case "shake": case "rumble": { //Make the shake in place for some time [effect,shake,x,y,frames,intensity]
						var x_ = real_ext(len > 1 ? param[1] : "0"), y_ = real_ext(len > 2 ? param[2] : "0"), time_ = real_ext(len > 3 ? param[3] : 5), off_ = real_ext(len > 4 ? param[4] : 2)
						 x_ = x_ != "" ? bool(x_) : false; y_ = y_ != "" ? bool(y_) : false;
						 soupy_alarm_set("face shaker", "timer", time_);
						soup_store("face shaker", { x_, y_, time_, off_ }); delayfunc();
					} break;
				}
			}
			scribble_typists_add_event("effect", efxfunc); scribble_typists_add_event("fx", efxfunc);
		#endregion
		
		#region Macros
			scribble_add_macro("icon", function(param, index_ = 0, spd_ = 1) { var result = get_icon(param) return result != -1 ? $"[{result},{index_},{spd_}]" : ""; }); //Icon helper tag [icon,funnytext game over]
			scribble_add_macro("face_spr", function(name_, expression_ = -1, index_ = 0, spd_ = 1) { var result = get_face(name_, expression_) return result != -1 ? $"[{result},{index_},{spd_}]" : ""; }); //Icon helper tag [face_spr,toriel happy]
			scribble_add_macro("newlp", function() { return "\n  "; }); //Newline with no asterisk and it's padded out
			scribble_add_macro("newla", function() { return "\n* "; }); //Newline with asterisk and a space
			scribble_add_macro("newl", function() { return chr(10); }); //Newline literal
			scribble_add_macro("pg", function() { return "[/page]"; }); //Page shorthand
			scribble_add_macro("wait", function(param = 1) { var real_ = real_ext(param); return $"[delay,{real_ != "" ? real_  * 1000 : 0}]"; }); //Delay tag that converts seconds to milliseconds [wait,1] 
			scribble_add_macro("repeat", function(phrase_ = "", times_ = 1, startwith_ = "", endwith_ = "") { //Repeats a phrase for a specified time with an optional parameter to end and start it off with another phrase [repeat,phrase,times,startwith,endwith]
				var real_ = string_digits(times_); if ( real_ == "" ) { return ""; }
				var string_ = "";
				string_ += startwith_; repeat ( real_ ) { string_ += phrase_; } string_ += endwith_;
				return string_;
			});
			scribble_add_macro("test", function(param) { //Various stress tests and testing suites
				switch ( param ) {
					//Stress test the typewriter gif export
					case "fullpage": { return "[repeat,s,96][newl][/page][c_red][repeat,o,96][newl][/page][c_gold][repeat,u,96][newl][/page][/][rainbow][repeat,p,96][newl][/page][/][shake][face,spr_toriel_mortified][repeat,y,72][face_stick]"; break; }
					//Tests various dialogue portrait effects
					case "soupy": { return "[face,soupy happy][fx,ghost,0,0][fx,ghost,1][fx,move,-20,,0][fx,move,,,,1]There's an option to [c_cyan][slant]hide the dialogue box[/slant][/] if you just want the[face_stick_all][skip][newl][/page]typewriter text.[/page]Very useful for [wheel]UTDR animations![/wheel][delay][newl][face,soupy goodjob][fx,squeeze][shake]I'm so soupyyy!![face_stick]"; break; }
					//Test the various funnytext
					case "funnytext": { return "[scale,0.65][icon,funnytext game over][wait,3][newl][/page][scale,0.5][spr_dw_tv_time_its][delay]  [spr_dw_tv_time_t][delay][offset,-50,15][spr_dw_tv_time_v][offsetPop][delay][offset,-30][spr_dw_tv_time_time][delay][newl][/page][scale,0.6][icon,funnytext dark fountain][wait,3][newl][/page][scale,0.65][spr_funnytext_physical_challenges][wait,3][newl][/page][scale,1.3][funnytext_tears][wait,3][newl][/page][scale,1.3][spr_funnytext_win][wait,3][newl][/page][scale,0.4][spr_funnytext_win_big][wait,3][newl][/page][scale,1.45][spr_funnytext_flames][wait,3]"; break; }
					//Test all the effects
					case "effects": { return "[wave]Wavy text.[/wave] [wheel]Wheel text.[/wheel] [shake]Shaky text.[/shake] [wobble]Wobbly text.[/wobble] [pulse]Pulse text.[/pulse] [rainbow]Rainbow text.[/rainbow] [slant]Slanted text.[/slant][newl][/page][scale,0.5]Scaled text.[/scale] [cycle,70,150]Color cycling text.[/cycle] [blink]Blink text.[/blink] [alpha,0.5]Different alpha.[/alpha][newl][/page][speed,4]Speedy text test: aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"; break; }
					//Test dialogue stacking
					case "stack": { return "[repeat,test[newl][/page]test2[newl][/page]test3[newl][/page]test4[newl][/page]test5[newl][/page]test6[newl][/page]test7[newl][/page]test8[newl][/page]test9,5]"; break; }
					//Test overloading the dialogue stack
					case "overload": { return "[test,stack][/page][test,stack]"; break; }
					
					case "basic": { return "Test text 1, 2, 3.[newl]Test text 4, 5, 6.[newl]Test text 7, 8, 9.[/page][c_red]Test text 1, 2, 3.[newl]Test text 4, 5, 6.[newl]Test text 7, 8, 9."; break; }
					default: { return "Testing suite ID not found."; }
				}
			});
		#endregion
	#endregion
#endregion

#region Dialogue Shadow
	dial_text_shdw = false; //Whether text should have a shadow
	dial_text_shdw_clr = c_deltarune; //Shadow Color
#endregion

#region Dialogue Face
	dial_face[dial_text_page] = -1; //Dialogue Face
	dial_face_index[dial_text_page] = 0; //Dialogue Face Frame
	dial_face_prev[dial_text_page] = -1; //Previous Dial Face
	dial_face_original[dial_text_page] = -1; //Original Dial Face
	dial_face_auto = true; //Whether to automatically animate the sprite when dialogue is typing
	dial_face_spd[dial_text_page] = 0; //Dialogue face speed
	dial_face_clr = c_white; //Dialogue Face Clr
	dial_face_name[dial_text_page] = -1; //Dialogue Portrait Internal Name
	dial_face_keep = true; //Whether to always keep the last dialogue face or reset back to the original face
	dial_face_xscale = 2; dial_face_yscale = 2; //Dialogue Face Xscale & Yscale
	dial_face_xscale_off = 0; dial_face_yscale_off = 0; //Dialogue Face Xscale & Yscale offset, for animation
	dial_face_angle = 0; //Dialogue Face Rotation
	dial_face_alpha = 1; //Dialogue Face Alpha
	dial_face_xoff = 0; dial_face_yoff = 0; //Dialogue Face X & Y offset, for animation
	dial_face_anim = 2; //How many letters should pass before animating the face?
	
	dial_face_alpha_orig = dial_face_alpha;  //Original alpha to revert back to
	dial_face_angle_orig = dial_face_angle;  //Original angle to revert back to
#endregion

#region Engine UI
	fader = 1; TweenFire("$10", "+10", "fader>", 0); //Black overlay
	ui_tab = 0; //Current Tab (0 - Dialogue, 1 - Face, 2 - Border, 3 - About)
	scrib_parse = { start_: "[", end_: "]", arg_: ",", } //Scribble tag parser 
	screenshot = false; //Screenshot task
	screenshot_stacked = false; //Whether dialogue exports are stacked
	screenshot_surf = -1; //Screenshot surface
	screenshot_back = c_lime; //Color for GIF background clearing
	record = { enabled: false, type: 0, frames: 0, framesmax: 0, id_: -1, quant: 1, delay: 60, }; //Whether to record, the type of recording(0 - static, 1 - wait for dialogue to finish), and how long to record for
	ui_visible = true; //Whether the UI should be visible
	ui_effoff = 0; //Effects array offset 
	ui_tab_yoff = 0; //Y offset for the orange and white borders
	ui_paused = false; //Whether to freeze ui elements
	file_dragging = false; //Whether a file is being dragged on screen.
	file_newname = ""; //New name for the file
	ui_mainfont = fnt_speech;
	
	#region Main Menu Buttons
		var i = 0, spr_ = spr_border_octagon, x_ = 320, y_ = 12, clr_ = c_orange, padd_ = 14;
		butt[i] = new Button({ id_: i, text: "Dialogue [spr_gui_icons,0]", x: x_, y: y_, yoff: 0, padd_multi: padd_, sprite: spr_, color_butt: clr_, color: clr_, on_hover: -1, on_enter: -1, on_leave: -1, on_click: -1, centered: false, });
		with ( butt[i++].data ) { self[$ "on_hover"] = method(self, on_hover_); self[$ "on_enter"] = method(self, on_enter_); self[$ "on_leave"] = method(self, on_leave_); self[$ "on_click"] = method(self, on_click_); }
		butt[i] = new Button({ id_: i, text: "Style        [spr_gui_icons,4]", x: x_, y: y_, yoff: 0, padd_multi: padd_, sprite: spr_, color_butt: clr_, color: clr_, on_hover: -1, on_enter: -1, on_leave: -1, on_click: -1, centered: false, });
		with ( butt[i++].data ) { self[$ "on_hover"] = method(self, on_hover_); self[$ "on_enter"] = method(self, on_enter_); self[$ "on_leave"] = method(self, on_leave_); self[$ "on_click"] = method(self, on_click_); }
		butt[i] = new Button({ id_: i, text: "Portrait [spr_gui_icons,1]", x: x_, y: y_, yoff: 0, padd_multi: padd_, sprite: spr_, color_butt: clr_, color: clr_, on_hover: -1, on_enter: -1, on_leave: -1, on_click: -1, centered: false, });
		with ( butt[i++].data ) { self[$ "on_hover"] = method(self, on_hover_); self[$ "on_enter"] = method(self, on_enter_); self[$ "on_leave"] = method(self, on_leave_); self[$ "on_click"] = method(self, on_click_); }
		butt[i] = new Button({ id_: i, text: "Border      [spr_gui_icons,2]", x: x_, y: y_, yoff: 0, padd_multi: padd_, sprite: spr_, color_butt: clr_, color: clr_, on_hover: -1, on_enter: -1, on_leave: -1, on_click: -1, centered: false, });
		with ( butt[i++].data ) { self[$ "on_hover"] = method(self, on_hover_); self[$ "on_enter"] = method(self, on_enter_); self[$ "on_leave"] = method(self, on_leave_); self[$ "on_click"] = method(self, on_click_); }
		butt[i] = new Button({ id_: i, text: "Extras      [spr_gui_icons,3]", x: x_, y: y_, yoff: 0, padd_multi: padd_, sprite: spr_, color_butt: clr_, color: clr_, on_hover: -1, on_enter: -1, on_leave: -1, on_click: -1, centered: false, });
		with ( butt[i++].data ) { self[$ "on_hover"] = method(self, on_hover_); self[$ "on_enter"] = method(self, on_enter_); self[$ "on_leave"] = method(self, on_leave_); self[$ "on_click"] = method(self, on_click_); }
		call_later(1, time_source_units_frames, on_reset_); //Reset all buttons on start
	#endregion

	#region Textbox
		quill_change = false; //QuillMulti()
		textinput = QuillMulti(, "(Click here to start typing!)\n(Your raw text input lives here. Processed output is below.)\n(Click on the quick buttons above to quickly insert text colors\n and effects. Try highlighting portions of texts!)\n(All done? Just press ESC for export options!)\n \n   (Happy generating and make sure to eat some good soup!!)")
			.SetInputMode(QUILL_TEXTMODE_TEXT).SetWrap(false).AllowActions(false).SetResizable(false).SetUseOverlayEditor(false)
			.SetTabInserts(true).SetTabUsesSpaces(false).SetTabSpaces(4)
			.SetCaretBlink(false).SetCaretFade(true).SetCaretFadeTime(250).SetCaretRepeatRate(10)
			.OnBlur(function() { //Theme for inactivity
				var quill_soup_inactive = new QuillTheme();
				quill_soup_inactive.textbox.text_col = #9d8cbb; quill_soup_inactive.textbox.placeholder_col = #9d8cbb; quill_soup_inactive.textbox.line_highlight_a = 0;
				quill_soup_inactive.skins.prim_bg_idle_col = #524271; quill_soup_inactive.skins.prim_bg_active_col = #292138; quill_soup_inactive.skins.prim_bg_hover_col = #625279; quill_soup_inactive.skins.prim_border_thickness = 0;
				quill_soup_inactive.scrollbar.border_col = #9d8cbb; quill_soup_inactive.scrollbar.border_a = 1; quill_soup_inactive.scrollbar.track_col = #9d8cbb; quill_soup_inactive.scrollbar.track_a = 1; quill_soup_inactive.scrollbar.thumb_idle_col = #d6b5dd; quill_soup_inactive.scrollbar.thumb_idle_a = 1;
				quill_soup_inactive.fonts.mainfont = SYSTEMUI.ui_mainfont;
				QuillSetTheme(quill_soup_inactive);
			})
			.OnFocus(function() { //Theme for activity
				var quill_soup_active = new QuillTheme();
				quill_soup_active.textbox.text_col = c_white; quill_soup_active.textbox.placeholder_col = #9d8cbb; quill_soup_active.textbox.line_highlight_col = #503f6e;
				quill_soup_active.skins.prim_bg_idle_col = #524271; quill_soup_active.skins.prim_bg_active_col = #292138; quill_soup_active.skins.prim_bg_hover_col = #625279; quill_soup_active.skins.prim_border_thickness = 0;
				quill_soup_active.scrollbar.thumb_active_col = #9a89b8; quill_soup_active.scrollbar.thumb_active_a = 1; quill_soup_active.scrollbar.track_col = #503f6e; quill_soup_active.scrollbar.track_a = 1; quill_soup_active.scrollbar.border_col = #503f6e; quill_soup_active.scrollbar.border_a = 1;
				quill_soup_active.selection.bg_col = #d6b5dd; 
				quill_soup_active.menu.item_hover_col = #9d8cbb; quill_soup_active.menu.bg_spr = spr_border_undertale; quill_soup_active.menu.prim_bg_col = c_white; quill_soup_active.menu.prim_bg_a = 1; quill_soup_active.menu.prim_border_col = c_black; quill_soup_active.menu.text_col = c_white; quill_soup_active.menu.sep_col = #9d8cbb; quill_soup_active.menu.disabled_text_col = #625279; quill_soup_active.menu.sep_h = 3; quill_soup_active.menu.pad_x = 10; quill_soup_active.menu.pad_y = 20; quill_soup_active.menu.item_hover_a = 1; quill_soup_active.menu.prim_padd = 2; quill_soup_active.menu.min_w = 200;
				quill_soup_active.fonts.mainfont = SYSTEMUI.ui_mainfont;
				QuillSetTheme(quill_soup_active);
			})
			
			#region Context Menu
				textinput.ContextMenuAddItem(QuillContextMenuItem("Copy", method(self, function () { //Copy text to clipboard
					var txt_ = textinput.GetSelection(), result = string_copy_at(textinput.GetValue(), txt_.start + 1, txt_._end + 1) ;
					if ( clipboard_get_text() != result ) { clipboard_set_text(result); sfx_play(snd_equip); } else { sfx_play(snd_cancel); }
				}), "soupy_copy").SetShortcut("Ctrl+C"))
				.ContextMenuAddItem(QuillContextMenuItem("Cut", method(self, function () { //Copy text to clipboard, then delete text
					var txt_ = textinput.GetSelection(), result = string_copy_at(textinput.GetValue(), txt_.start + 1, txt_._end + 1), finalresult = string_delete_at(textinput.GetValue(), txt_.start + 1, txt_._end + 1);
					clipboard_set_text(result); sfx_play(snd_throw); textinput.SetValue(finalresult); dial_updatet = 1; textinput.SetCaret(txt_.start);
				}), "soupy_cut").SetShortcut("Ctrl+X"))
				.ContextMenuAddItem(QuillContextMenuItem("Paste", method(self, function () { //Paste text from clipboard
					var caret_ = textinput.GetCaret(), txt_ = textinput.GetValue(), select_ = textinput.GetSelection();
					if ( !select_.has_selection ) { //Paste text
						var result = string_insert(clipboard_get_text(), txt_, caret_ + 1);
						sfx_play(snd_bump);
					}
					else { //Delete selection, then paste text
						var remove_ = string_delete_at(txt_, select_.start + 1, select_._end + 1);
						var result = string_insert(clipboard_get_text(), remove_, caret_ + 1);
						sfx_play(snd_enc1);
					}
					textinput.SetValue(result); dial_updatet = 1; textinput.SetCaret(caret_);
				}), "soupy_paste").SetShortcut("Ctrl+V"))
				.ContextMenuAddItem(QuillContextMenuSeparator())
				.ContextMenuAddItem(QuillContextMenuItem("Select All", method(self, function () { textinput.SelectAll(); sfx_play(snd_enc1); }), "soupy_select").SetShortcut("Ctrl+A"))
				.ContextMenuAddItem(QuillContextMenuItem("Clear All", method(self, soupy_context_clear), "soupy_clear").SetShortcut("Ctrl+S"))
				.ContextMenuAddItem(QuillContextMenuSeparator())
				.ContextMenuAddItem(QuillContextMenuItem("Insert Page", method(self, soupy_context_page), "soupy_page").SetShortcut("Ctrl+D"))
				.on_blur();
			#endregion
	#endregion
#endregion

#region Menu Sections
	#region Init Style
		var soupy_style = new LuiStyle({ padding: 15, gap: 10, color_text: c_white, color_hover: c_yellow, sound_click: snd_select, sound_hover: snd_sel_switch, }) //Main Style
			.setRenderRegionOffset([10, 10, 10, 10])
			.setFonts(fnt_determination, fnt_determination, fnt_determination).setColors(, c_orange, #f43e83, #15ee97)
			.setSprites(spr_border_undertale_outlined, spr_border_undertale_outlined).setSpriteCheckbox(spr_border_undertale_outlined, spr_pixel).setSpriteComboBoxArrow(spr_soul_tiny)
		soupy_lui = new LuiMain().setStyle(soupy_style);
	#endregion
		
	#region Portrait Panel
		var x1_ = 10, y1_ = 45, x2_ = 600, y2_ = 385, w_ = x2_ - x1_, h_ = y2_ - y1_;
		soupy_panel_portrait = new LuiScrollPanel({ x: 10, y: 45, width: w_, height: h_, scroll_pin_edge_offset:10, sprite_panel: false, sound_right: snd_throw, }); //Start containter
		
			var panel_base_ = { text: "", color: c_orange, sprite_button: spr_border_header, height: 40, font: fnt_speech, text_color: c_black, sound_click: snd_enc1, sound_click_pitch: 1.3, };
			var panel_ = new LuiContainer().setPadding(0).addContent([
				new LuiRow().setFlexGrow(1).centerContent().addContent([ //Choosing a sprite
					new LuiText({ value: "Sprite:", width: 65, text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }).setTooltip("Changes the portrait sprite.\nThis value can be [rainbow]changed dynamically[/]\nif using [c_yellow][[face,character,expression][/]\nor [c_yellow][[face,filename][/]. Set to [c_red]-1[/] for no\ndialogue portrait.", true, , true),
					new LuiButton({ text: "Choose...", height: 40, width: 100, }).addEvent(LUI_EV_CLICK, external_choose_face),
					new LuiInput({ height: 40, placeholder: "or type. (ex: spr_face_test)", offset: 12, type_sfx: snd_txttype, color_normal: c_white, color_hover: c_gray, }).addEvent(LUI_EV_CREATE, function(e_) { soup_store("datainput", e_, , true); }).addEvent(LUI_EV_VALUE_UPDATE, function(e_) { 
						var spr_ = soup_checkout("dataimage", false, true), getface = get_face(e_.get()); 
						spr_.set(getface == -1 ? spr_gui_icons : getface); spr_.subimg = ( getface == -1 ? 3 : 0 );
						FACE_CURRENT = getface; FACE_INTERNAL = e_.get(); if ( getface != -1 ) { sfx_play(snd_updated); }
					}),
					new LuiImage({ draw_normal: true, }).setSize(70, 70).addEvent(LUI_EV_CREATE, function(e_) { soup_store("dataimage", e_, , true); }).addEvent(LUI_EV_SHOW, function(e_) { 
						var input_ = soup_checkout("datainput", false, true), spr_ = soup_checkout("dataimage", false, true);
						spr_.set(FACE_CURRENT == -1 ? spr_gui_icons : FACE_CURRENT).setSubimg(FACE_CURRENT == -1 ? 3 : 0).setColor(SYSTEMUI.dial_face_clr);
						input_.set(FACE_CURRENT == -1 ? "" : FACE_INTERNAL); 
					}).addEvent(LUI_EV_MOUSE_LEFT_PRESSED, function(element_) { element_.main_ui.animate(element_, "xscale", 1, 0.15, , 0.7); element_.main_ui.animate(element_, "yscale", 1, 0.15, , 1.3); sfx_play(snd_squish); })
					   .addEvent(LUI_EV_CLICK_R, function(element_) {
							var input_ = soup_checkout("datainput", false, true), spr_ = soup_checkout("dataimage", false, true);
							if ( spr_.get() != spr_gui_icons && input_.get() != "" ) { spr_.set(spr_gui_icons).setSubimg(3).setColor(SYSTEMUI.dial_face_clr); input_.set(""); sfx_play(snd_hurtpowerful); }
						}),
				]),
					
				new LuiRow().setFlexGrow(1).centerContent().addContent([ //Sprite image index
					new LuiText({ value: "Image Index:", width: 110, text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }).setTooltip("Changes the image number of the\ncurrent dialogue portrait displaying.\nThis value can be [rainbow]changed dynamically[/]\nif using [c_yellow][[face_index,#][/].\n[c_yellow][slant]Sync With Dialogue[/] will be switched [c_red]off[/].", true, , true),
					new LuiInput({ height: 40, placeholder: "123456", offset: 12, type_sfx: snd_txttype, color_normal: c_white, color_hover: c_gray, input_mode: LUI_INPUT_MODE.numbers, }).addEvent(LUI_EV_SHOW, function(e_) { e_.set(FACE_CURRENT != -1 ? FACE_INDEX : 0); }).addEvent(LUI_EV_VALUE_UPDATE, function(e_) { 
						if ( dial_text_gif ) { exit; }
						var spr_ = soup_checkout("dataimage", false, true), value_ = e_.get(), index_ = real(value_ == "" ? 0 : value_);
						if ( spr_.get() != spr_gui_icons ) { spr_.setSubimg(index_); FACE_INDEX = index_; }
						if ( dial_face_auto && soup_checkout("triggered") != undefined ) { dial_face_auto = false; }
					}).addEvent(LUI_EV_CLICK, function(e_) { soup_store("triggered"); }),
				]),
					
				new LuiRow().setFlexGrow(1).centerContent().addContent([ //Sprite image speed
					new LuiText({ value: "Image Speed:", width: 110, text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }).setTooltip("Changes the animation speed of the\ncurrent dialogue portrait displaying.\nThis value can be [rainbow]changed dynamically[/]\nif using [c_yellow][[face_speed,#][/].\n[c_yellow][slant]Sync With Dialogue[/] will be switched [c_red]off[/].", true, , true),
					new LuiInput({ height: 40, placeholder: "123456", offset: 12, type_sfx: snd_txttype, color_normal: c_white, color_hover: c_gray, }).addEvent(LUI_EV_SHOW, function(e_) { e_.set(FACE_CURRENT != -1 ? FACE_SPEED : 0); }).addEvent(LUI_EV_VALUE_UPDATE, function(e_) { 
						if ( dial_text_gif ) { exit; }
						var spr_ = soup_checkout("dataimage", false, true), value_ = real_ext(e_.get()), index_ = value_ == "" ? 0 : value_;
						if ( spr_.get() != spr_gui_icons ) { spr_.imgspd = index_; FACE_SPEED = index_; }
						if ( dial_face_auto && soup_checkout("triggered") != undefined ) { dial_face_auto = false; }
					}).addEvent(LUI_EV_CLICK, function(e_) { soup_store("triggered"); }),
				]),
			]);
			var panel_header_ = new LuiButton(panel_base_).setText("Current Face Settings").setTooltip("These settings only affect the dialogue\nportrait on the [wave][c_cyan]current highlighted page.", true, , true).setData("header", panel_).setIcon(spr_gui_icons,,, c_black,, 1).addEvent(LUI_EV_CLICK, function(e_) { var header = e_.getData("header"); header.toggleVisible(); }); soupy_panel_portrait.addContent([panel_header_, panel_, ]); //End container
				
			var panel_ = new LuiContainer().setPadding(0).addContent([
				new LuiRow().setFlexGrow(1).centerContent().addContent([ //Sprite image index
					new LuiText({ value: "Talk Speed:", width: 110, text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }).setTooltip("Changes how often portraits animate\nbased on how many letters needs to\nbe revealed.", true, , true),
					new LuiInput({ value: dial_face_anim, height: 40, placeholder: "123456", offset: 12, type_sfx: snd_txttype, color_normal: c_white, color_hover: c_gray, input_mode: LUI_INPUT_MODE.numbers, }).addEvent(LUI_EV_CREATE, function(e_) { e_.set(floor(SYSTEMUI.dial_face_anim)); })
					.addEvent(LUI_EV_VALUE_UPDATE, function(e_) { var result = e_.get(); SYSTEMUI.dial_face_anim = real(result == "" ? 2 : result); }),
				]),
				
				new LuiRow().setFlexGrow(1).centerContent().addContent([ //Choosing a color
					new LuiText({ value: "Color:", width: 65, text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }).setTooltip("Changes the color of every dialogue portrait.\nThis value can be [rainbow]changed dynamically[/]\nif using [c_yellow][[effect,color,R,G,B,time]", true, , true),
					new LuiButton({ text: "Pick...", height: 40, }).addEvent(LUI_EV_CLICK, soupy_color_picker_portrait),
					new LuiImage({ value: spr_face_test, draw_normal: true, }).setSize(70, 70).addEvent(LUI_EV_CREATE, function(e_) { soup_store("datacolor", e_, , true); }).addEvent(LUI_EV_MOUSE_LEFT_PRESSED, function(element_) { element_.main_ui.animate(element_, "xscale", 1, 0.15, , 0.7); element_.main_ui.animate(element_, "yscale", 1, 0.15, , 1.3); sfx_play(snd_squish); })
					.addEvent(LUI_EV_VALUE_UPDATE, function(e_) { SYSTEMUI.dial_face_clr = e_.color_blend; e_.set(spr_face_test); soup_checkout("dataimage", false, true).setColor(e_.color_blend); audio_stop_sound(snd_equip2); sfx_play(snd_equip2, , , 1.3); }).addEvent(LUI_EV_CLICK_R, function(e_) { if ( e_.color_blend == c_white ) { exit; } e_.main_ui.animate(e_, "xscale", 1, 0.15, , 0.7); e_.main_ui.animate(e_, "yscale", 1, 0.15, , 1.3); e_.setColor(c_white); soup_checkout("dataimage", false, true).setColor(c_white); SYSTEMUI.dial_face_clr = c_white; sfx_play(snd_hurtpowerful); }),
				]),
					
				new LuiRow().setFlexGrow(1).centerContent().addContent([ //Sprite image scale
					new LuiText({ value: "Scale:", width: 65, text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }).setTooltip("Changes the scale of every dialogue portrait.\nThis value can be [rainbow]changed dynamically[/]\nif using [c_yellow][[effect,scale,X,Y,frames,issmooth]", true, , true),
					new LuiInput({ value: "2", height: 40, placeholder: "123456", offset: 12, type_sfx: snd_txttype, color_normal: c_white, color_hover: c_gray, input_mode: LUI_INPUT_MODE.numbers, }).bindVariable(self, "dial_face_xscale").addEvent(LUI_EV_VALUE_UPDATE, function(e_) { 
						var get_ = e_.get(), value_ = real(get_ == "" ? 2 : get_); SYSTEMUI.dial_face_xscale = value_; SYSTEMUI.dial_face_yscale = value_;
					}),
				]),
					
				new LuiRow().setFlexGrow(1).centerContent().addContent([ //Sprite image angle
					new LuiText({ value: "Angle:", width: 65, text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }).setTooltip("Changes the angle of every dialogue portrait.\nThis value can be [rainbow]changed dynamically[/]\nif using [c_yellow][[effect,rotate,#,frames,issmooth]", true, , true),
					new LuiSlider({ min_value: 0, color_text: c_black, color_text_drag: c_white, max_value: 360, rounding: true, display_value: true, bar_sprite: spr_border_header, bar_sprite_back: spr_border_header, }).addEvent(LUI_EV_CREATE, function(e_) { e_.set(SYSTEMUI.dial_face_angle); }).addEvent(LUI_EV_VALUE_UPDATE, function(e_) { 
						var value_ = real(e_.get()); SYSTEMUI.dial_face_angle = value_; SYSTEMUI.dial_face_angle_orig = SYSTEMUI.dial_face_angle; soup_checkout("dataimage", false, true).angle = value_;
					}),
				]),
					
				new LuiRow().setFlexGrow(1).centerContent().addContent([ //Sprite image alpha
					new LuiText({ value: "Opacity:", width: 85, text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }).setTooltip("Changes the alpha of every dialogue portrait.\nThis value can be [rainbow]changed dynamically[/]\nif using [c_yellow][[effect,fade,#,frames]", true, , true),
					new LuiSlider({ value: dial_face_alpha, min_value: 0, color_text: c_black, color_text_drag: c_white, max_value: 1, rounding: false, display_value: true, bar_sprite: spr_border_header, bar_sprite_back: spr_border_header, }).addEvent(LUI_EV_CREATE, function(e_) { e_.set(SYSTEMUI.dial_face_alpha); }).addEvent(LUI_EV_VALUE_UPDATE, function(e_) { 
						var value_ = real(e_.get()); SYSTEMUI.dial_face_alpha = value_; SYSTEMUI.dial_face_alpha_orig = SYSTEMUI.dial_face_alpha; soup_checkout("dataimage", false, true).angle = value_;
					}),
				]),
					
				new LuiHorizontalRule({ height: 5, }),
				new LuiRow().setFlexGrow(1).centerContent().addContent([ //Animate with dialogue
					new LuiText({ value: "Sync with dialogue:", width: 185, text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }).setTooltip("Whether to animate the face while\ndialogue is typing out.\nThis value can be [rainbow]changed dynamically[/]\nif using [c_yellow][[face_auto,\"true\" or \"false\"]", true, , true),
					new LuiToggleSwitch({ value: dial_face_auto, ease: global.Ease.OutBack, sound_click: snd_bump, sound_click_pitch: 1.3,  }).bindVariable(self, "dial_face_auto"),
				]),
					
				new LuiRow().setFlexGrow(1).centerContent().addContent([ //Keep original dialogue face
					new LuiText({ value: "Keep previous face:", width: 185, text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }).setTooltip("Whether to always keep the last dialogue face\nor reset back to the original face.\nThis value can be [rainbow]changed dynamically[/]\nif using [c_yellow][[face_orig,character,expression]", true, , true),
					new LuiToggleSwitch({ value: dial_face_keep, ease: global.Ease.OutBack, sound_click: snd_bump, sound_click_pitch: 1.3,  }).bindVariable(self, "dial_face_keep"),
				]),
			]);
			var panel_header_ = new LuiButton(panel_base_).setText("Global Face Settings").setTooltip("These settings affect [wave][c_red]all[/] dialogue portraits.", true, , true).setData("header", panel_).setIcon(spr_gui_icons,,, c_black,, 5).addEvent(LUI_EV_CLICK, function(e_) { var header = e_.getData("header"); header.toggleVisible(); }); soupy_panel_portrait.addContent([panel_header_, panel_, ]); //End container
		
		soupy_lui.addContent(soupy_panel_portrait); //Add everything to the main ui
	#endregion
		
	#region Border Panel
		var x1_ = 10, y1_ = 45, x2_ = 600, y2_ = 385, w_ = x2_ - x1_, h_ = y2_ - y1_;
		soupy_panel_border = new LuiScrollPanel({ x: 10, y: 45, width: w_, height: h_, scroll_pin_edge_offset:10, sprite_panel: false, sound_right: snd_throw, }) //Start containter
		.addContent([
			new LuiRow().setFlexGrow(1).centerContent().addContent([ //Choosing a sprite
				new LuiText({ value: "Sprite:", width: 65, text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }).setTooltip("Changes the border sprite.\nThis value can be [rainbow]changed dynamically[/]\nif using [c_yellow][[border,sprite name][/].", true, , true),
				new LuiButton({ text: "Choose...", height: 40, width: 100, }).addEvent(LUI_EV_CLICK, external_choose_border),
				new LuiInput({ value: sprite_get_name(SYSTEMUI.spr_bord), height: 40, placeholder: "or type. (ex: spr_border_deltarune)", offset: 12, type_sfx: snd_txttype, color_normal: c_white, color_hover: c_gray, }).addEvent(LUI_EV_CREATE, function(e_) { soup_store("datainputB", e_, , true); }).addEvent(LUI_EV_VALUE_UPDATE, function(e_) { 
					var spr_ = soup_checkout("dataimageB", false, true), getface = get_border(e_.get()); 
					spr_.set(getface == -1 ? spr_border_undertale : getface); spr_.subimg = SYSTEMUI.bord_index;
					SYSTEMUI.spr_bord = (getface == -1 ? spr_border_undertale : getface); SYSTEMUI.bord_prev = SYSTEMUI.spr_bord; bord_name = (getface == -1 ? "spr_border_undertale" : e_.get()); if ( getface != -1 ) { sfx_play(snd_updated); }
				}),
				new LuiImage({ value: SYSTEMUI.spr_bord, maintain_aspect: false, xscale: 0, yscale: 0, }).setSize(70, 70).addEvent(LUI_EV_CREATE, function(e_) { soup_store("dataimageB", e_, , true); e_.bounce = SYSTEMUI.bord_anim; }).addEvent(LUI_EV_SHOW, function(e_) { 
					var input_ = soup_checkout("datainputB", false, true);
					e_.set(SYSTEMUI.spr_bord).setSubimg(SYSTEMUI.bord_index).setColor(SYSTEMUI.bord_clr);
					input_.set(bord_name); 
				}).addEvent(LUI_EV_MOUSE_LEFT_PRESSED, function(element_) { element_.main_ui.animate(element_, "xscale", 0, 0.15, , 5); element_.main_ui.animate(element_, "yscale", 0, 0.15, , 5); sfx_play(snd_squish); })
				   .addEvent(LUI_EV_VALUE_UPDATE, function(e_) { audio_stop_sound(snd_equip2); sfx_play(snd_equip2, , , 1.3); TweenScript(SYSTEMUI, 0, 2, function() { var e_ = soup_checkout("dataimageB", false, true); e_.set(SYSTEMUI.spr_bord); }); SYSTEMUI.bord_clr = e_.color_blend; }).addEvent(LUI_EV_CLICK_R, function(e_) {
					var input_ = soup_checkout("datainputB", false, true); SYSTEMUI.spr_bord = spr_border_undertale; SYSTEMUI.bord_prev = SYSTEMUI.spr_bord;
					input_.set("spr_border_undertale"); audio_stop_sound(snd_updated); sfx_play(snd_hurtpowerful); e_.main_ui.animate(e_, "xscale", 0, 0.15, , 5); e_.main_ui.animate(e_, "yscale", 0, 0.15, , 5); e_.setColor(c_white); SYSTEMUI.bord_clr = c_white;
				}),
			]),
			
			new LuiRow().setFlexGrow(1).centerContent().addContent([ //Choosing a color
				new LuiText({ value: "Color:", width: 65, text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }).setTooltip("Changes the color of the dialogue border.\nThis value can be [rainbow]changed dynamically[/]\nif using [c_yellow][[fx,colorborder,r,g,b,frames][/].", true, , true),
				new LuiButton({ text: "Pick...", height: 40, }).addEvent(LUI_EV_CLICK, soupy_color_picker_border),
			]),
			
			new LuiRow().setFlexGrow(1).centerContent().addContent([ //Sprite image index
				new LuiText({ value: "Image Index:", width: 110, text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }).setTooltip("Changes the image number of the\ndialogue border.", true, , true),
				new LuiInput({ value: bord_index, height: 40, placeholder: "123456", offset: 12, type_sfx: snd_txttype, color_normal: c_white, color_hover: c_gray, input_mode: LUI_INPUT_MODE.numbers, }).addEvent(LUI_EV_CREATE, function(e_) { e_.set(floor(SYSTEMUI.bord_index)); })
				.addEvent(LUI_EV_VALUE_UPDATE, function(e_) { 
					var result = e_.get(); SYSTEMUI.bord_index = real(result == "" ? 0 : result);
					soup_checkout("dataimageB", false, true).setSubimg(SYSTEMUI.bord_index);
				}),
			]),
			
			new LuiRow().setFlexGrow(1).centerContent().addContent([ //Sprite image speed
				new LuiText({ value: "Image Speed:", width: 110, text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }).setTooltip("Changes the animation speed of the\ndialogue border.", true, , true),
				new LuiInput({ value: bord_spd, height: 40, placeholder: "123456", offset: 12, type_sfx: snd_txttype, color_normal: c_white, color_hover: c_gray, }).addEvent(LUI_EV_CREATE, function(e_) { e_.set(SYSTEMUI.bord_spd); })
				.addEvent(LUI_EV_VALUE_UPDATE, function(e_) { 
					var spr_ = soup_checkout("dataimageB", false, true), value_ = real_ext(e_.get()), index_ = value_ == "" ? 0 : value_; spr_.imgspd = index_; SYSTEMUI.bord_spd = index_;
				}),
			]),
			
			new LuiRow().setFlexGrow(1).centerContent().addContent([ //Sprite image scale
				new LuiText({ value: "Scale:", width: 65, text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }).setTooltip("Changes the scale of dialogue borders.\nOnly applies to [c_yellow]custom dialogue borders[/].", true, , true),
				new LuiInput({ value: bord_scale, height: 40, placeholder: "123456", offset: 12, type_sfx: snd_txttype, color_normal: c_white, color_hover: c_gray, }).addEvent(LUI_EV_CREATE, function(e_) { e_.set(SYSTEMUI.bord_scale); })
				.addEvent(LUI_EV_VALUE_UPDATE, function(e_) { 
					var spr_ = soup_checkout("dataimageB", false, true), value_ = real_ext(e_.get()), index_ = value_ == "" ? 2 : value_; SYSTEMUI.bord_scale = index_;
				}),
			]),
			
			new LuiRow().setFlexGrow(1).centerContent().addContent([ //Nine slice
				new LuiText({ value: "Nine Stretch:", width: 120, text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }).setTooltip("Whether [c_yellow]custom borders[/] should stretch\nto fill space instead of tiling.\n[c_red]Not applicable[/] for [c_yellow][slant]arbitrary borders[/].", true, , true),
				new LuiToggleSwitch({ value: bord_stretch, ease: global.Ease.OutBack, sound_click: snd_bump, sound_click_pitch: 1.3,  }).bindVariable(self, "bord_stretch"),
			]),
			
			new LuiRow().setFlexGrow(1).centerContent().addContent([ //Animation bounce back
				new LuiText({ value: "Bounce Back:", width: 110, text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }).setTooltip("Whether dialogue borders should reverse its\nanimation once their animation ends.", true, , true),
				new LuiToggleSwitch({ value: bord_anim, ease: global.Ease.OutBack, sound_click: snd_bump, sound_click_pitch: 1.3,  }).bindVariable(self, "bord_anim").addEvent(LUI_EV_VALUE_UPDATE, function(e_) { soup_checkout("dataimageB", false, true).bounce = e_.get(); }),
			]),
			
			new LuiRow().setFlexGrow(1).centerContent().addContent([ //Visbility
				new LuiText({ value: "Visible:", width: 110, text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }),
				new LuiToggleSwitch({ value: bord_anim, ease: global.Ease.OutBack, sound_click: snd_bump, sound_click_pitch: 1.3,  }).bindVariable(self, "bord_box_visible").addEvent(LUI_EV_VALUE_UPDATE, function(e_) { soup_checkout("dataimageB", false, true).setAlpha(e_.get()); }),
			]),
			
			new LuiHorizontalRule({ height: 5, }),
			new LuiRow().setFlexGrow(1).centerContent().addContent([
				new LuiText({ value: "Arbitrary Border:", width: 160, text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }).setTooltip("Whether to allow borders of [slant]any\narbitrary size and customization[/].\nThis means [c_red]nineslice is disabled[/] and\nyou'll need to provide a border sprite\nof exact size. This will also enable\n[c_yellow]Bigger Resolution[/].\nJust make sure your border isn't cluttering\nUI elements or else [shake]you won't be able to see!", true, , true),
				new LuiToggleSwitch({ value: global.pref.anyborder, ease: global.Ease.OutBack, sound_click: snd_bump, sound_click_pitch: 1.3,  }).bindVariable(global.pref, "anyborder").addEvent(LUI_EV_VALUE_UPDATE, function(e_) { SYSTEMUI.bord_scale = e_.get() ? 1 : 2; global.pref.sizematters = true; SYSTEMUI.save_pref(); }),
			]),
			
			new LuiRow().setFlexGrow(1).centerContent().addContent([ //Sprite image scale
				new LuiText({ value: "Text X Off:", width: 130, text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }).setTooltip("Offset dialogue text on the x axis.\nEspecially useful for [c_yellow][slant]arbitrary borders[/].", true, , true),
				new LuiInput({ value: dial_text_xoff, height: 40, placeholder: "123456", offset: 12, type_sfx: snd_txttype, color_normal: c_white, color_hover: c_gray, }).addEvent(LUI_EV_CREATE, function(e_) { e_.set(SYSTEMUI.dial_text_xoff); })
				.addEvent(LUI_EV_VALUE_UPDATE, function(e_) { var value_ = real_ext(e_.get()), index_ = value_ == "" ? 0 : value_; SYSTEMUI.dial_text_xoff = index_; }),
			]),
			
			new LuiRow().setFlexGrow(1).centerContent().addContent([ //Sprite image scale
				new LuiText({ value: "Text Y Off:", width: 130, text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }).setTooltip("Offset dialogue text on the y axis.\nEspecially useful for [c_yellow][slant]arbitrary borders[/].", true, , true),
				new LuiInput({ value: dial_text_yoff, height: 40, placeholder: "123456", offset: 12, type_sfx: snd_txttype, color_normal: c_white, color_hover: c_gray, }).addEvent(LUI_EV_CREATE, function(e_) { e_.set(SYSTEMUI.dial_text_yoff); })
				.addEvent(LUI_EV_VALUE_UPDATE, function(e_) { var value_ = real_ext(e_.get()), index_ = value_ == "" ? 0 : value_; SYSTEMUI.dial_text_yoff = index_; }),
			]),
			
			new LuiRow().setFlexGrow(1).centerContent().addContent([ //Sprite image scale
				new LuiText({ value: "Border X Off:", width: 150, text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }).setTooltip("Offset [c_yellow][slant]arbitrary borders[/] on the x axis.", true, , true),
				new LuiInput({ value: bord_xoff, height: 40, placeholder: "123456", offset: 12, type_sfx: snd_txttype, color_normal: c_white, color_hover: c_gray, }).addEvent(LUI_EV_CREATE, function(e_) { e_.set(SYSTEMUI.bord_xoff); })
				.addEvent(LUI_EV_VALUE_UPDATE, function(e_) { var value_ = real_ext(e_.get()), index_ = value_ == "" ? 0 : value_; SYSTEMUI.bord_xoff = index_; }),
			]),
			
			new LuiRow().setFlexGrow(1).centerContent().addContent([ //Sprite image scale
				new LuiText({ value: "Border Y Off:", width: 150, text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }).setTooltip("Offset [c_yellow][slant]arbitrary borders[/] on the y axis.", true, , true),
				new LuiInput({ value: bord_yoff, height: 40, placeholder: "123456", offset: 12, type_sfx: snd_txttype, color_normal: c_white, color_hover: c_gray, }).addEvent(LUI_EV_CREATE, function(e_) { e_.set(SYSTEMUI.bord_yoff); })
				.addEvent(LUI_EV_VALUE_UPDATE, function(e_) { var value_ = real_ext(e_.get()), index_ = value_ == "" ? 0 : value_; SYSTEMUI.bord_yoff = index_; }),
			]),
			
			new LuiRow().setFlexGrow(1).centerContent().addContent([ //Sprite image angle
				new LuiText({ value: "Border Angle:", width: 150, text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }).setTooltip("Change the rotation of [c_yellow][slant]arbitrary borders[/].", true, , true),
				new LuiSlider({ min_value: 0, color_text: c_black, color_text_drag: c_white, max_value: 360, rounding: true, display_value: true, bar_sprite: spr_border_header, bar_sprite_back: spr_border_header, }).bindVariable(self, "bord_angle").addEvent(LUI_EV_VALUE_UPDATE, function(e_) { 
					//var value_ = real(e_.get()); SYSTEMUI.bord_angle = value_;
				}),
			]),
		]);
		
		soupy_lui.addContent(soupy_panel_border); //Add everything to the main ui
	#endregion
		
	#region Style Panel
		var x1_ = 10, y1_ = 45, x2_ = 600, y2_ = 385, w_ = x2_ - x1_, h_ = y2_ - y1_;
		soupy_panel_style = new LuiScrollPanel({ x: 10, y: 45, width: w_, height: h_, scroll_pin_edge_offset:10, sprite_panel: false, sound_right: snd_throw, }) //Start containter
		.addContent([
			new LuiRow().setFlexGrow(1).centerContent().addContent([ //Choosing a sprite
				new LuiText({ value: "Font:", width: 65, text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }).setTooltip("Changes the dialogue font.\nThis value can be [rainbow]changed dynamically[/]\nif using [c_yellow][[font name](ex: [[fnt_sans])[/].", true, , true),
				new LuiButton({ text: "Choose...", height: 40, width: 100, }).addEvent(LUI_EV_CLICK, external_choose_font),
				new LuiInput({ value: dial_font, height: 40, placeholder: "or type. (ex: fnt_determination)", offset: 12, type_sfx: snd_txttype, color_normal: c_white, color_hover: c_gray, }).addEvent(LUI_EV_CREATE, function(e_) { soup_store("datainputS", e_, , true); }).addEvent(LUI_EV_VALUE_UPDATE, function(e_) { 
					var prev_ = soup_checkout("datafont", false, true), value = e_.get(); prev_.font = scribble_font_exists(value) ? value : "fnt_determination";
					SYSTEMUI.dial_font = prev_.font; audio_stop_sound(snd_updated); sfx_play(snd_updated);
				}),
				new LuiText({ value: "AaBbCc", width: 100, text_halign: fa_center, text_valign: fa_middle, font: dial_font, scribbletext: true, }).addEvent(LUI_EV_CREATE, function(e_) { soup_store("datafont", e_, , true); })
				.addEvent(LUI_EV_MOUSE_LEFT_PRESSED, function(element_) { element_.main_ui.animate(element_, "yoff", 0, 1, global.Ease.OutElastic, 10); sfx_play(snd_squish); })
				.addEvent(LUI_EV_CLICK_R, function(element_) {
					var input_ = soup_checkout("datainputS", false, true), spr_ = soup_checkout("datafont", false, true);
					if ( spr_.font != "fnt_determination" && input_.get() != "" ) { spr_.font = "fnt_determination"; input_.set(""); sfx_play(snd_hurtpowerful); audio_stop_sound(snd_updated); }
				}),
			]),
			
			new LuiRow().setFlexGrow(1).centerContent().addContent([ //Choosing a color
				new LuiText({ value: "Text Color:", width: 110, text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }).setTooltip("Changes the color of the text.\nThis value can be [rainbow]changed dynamically[/]\nif using [c_yellow][[color name][/].", true, , true),
				new LuiButton({ text: "Pick...", height: 40, }).addEvent(LUI_EV_CLICK, soupy_color_picker_textc),
				new LuiImage({ value: spr_pixel, maintain_aspect: false, color: dial_text_c }).setSize(80, 40).addEvent(LUI_EV_CREATE, function(e_) { soup_store("datatextc", e_, , true); }).addEvent(LUI_EV_MOUSE_LEFT_PRESSED, function(element_) { element_.main_ui.animate(element_, "xscale", 0, 1, global.Ease.OutElastic, 10); element_.main_ui.animate(element_, "yscale", 0, 1, global.Ease.OutElastic, 5); sfx_play(snd_squish); })
				.addEvent(LUI_EV_VALUE_UPDATE, function(e_) { e_.set(spr_pixel); SYSTEMUI.dial_text_c = e_.color_blend; audio_stop_sound(snd_equip2); sfx_play(snd_equip2, , , 1.3); }).addEvent(LUI_EV_CLICK_R, function(e_) { if ( e_.color_blend == c_white ) { exit; } e_.main_ui.animate(e_, "xscale", 0, 1, global.Ease.OutElastic, 10); e_.main_ui.animate(e_, "yscale", 0, 1, global.Ease.OutElastic, 5); e_.setColor(c_white); SYSTEMUI.dial_text_c = c_white; sfx_play(snd_hurtpowerful); }),
			]),
			
			new LuiRow().setFlexGrow(1).centerContent().addContent([ //Choosing a color
				new LuiText({ value: "Outline Color:", width: 130, text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }).setTooltip("Changes the color of the text outline.\nRight-click to remove outline.", true, , true),
				new LuiButton({ text: "Pick...", height: 40, }).addEvent(LUI_EV_CLICK, soupy_color_picker_textcout),
				new LuiImage({ value: spr_pixel, maintain_aspect: false, color: dial_text_outline }).setSize(80, 40).addEvent(LUI_EV_CREATE, function(e_) { soup_store("datatextcout", e_, , true); }).addEvent(LUI_EV_SHOW, function(e_) { e_.setColor(SYSTEMUI.dial_text_outline); })
				.addEvent(LUI_EV_MOUSE_LEFT_PRESSED, function(element_) { element_.main_ui.animate(element_, "xscale", 0, 1, global.Ease.OutElastic, 10); element_.main_ui.animate(element_, "yscale", 0, 1, global.Ease.OutElastic, 5); sfx_play(snd_squish); })
				.addEvent(LUI_EV_VALUE_UPDATE, function(e_) { e_.set(spr_pixel); SYSTEMUI.dial_text_outline = e_.color_blend; if ( !string_search(SYSTEMUI.dial_font, "_outline", true) ) { SYSTEMUI.dial_font = $"{SYSTEMUI.dial_font}_outline"; } audio_stop_sound(snd_equip2); sfx_play(snd_equip2, , , 1.3); }).addEvent(LUI_EV_CLICK_R, function(e_) { if ( e_.color_blend == -1 ) { exit; } e_.main_ui.animate(e_, "xscale", 0, 1, global.Ease.OutElastic, 10); e_.main_ui.animate(e_, "yscale", 0, 1, global.Ease.OutElastic, 5); e_.setColor(-1); SYSTEMUI.dial_text_outline = -1; SYSTEMUI.dial_font = string_replace(SYSTEMUI.dial_font, "_outline", ""); sfx_play(snd_hurtpowerful); }),
			]),
			
			new LuiRow().setFlexGrow(1).centerContent().addContent([
				new LuiText({ value: "Text Scale:", width: 110, text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }).setTooltip("Changes the scale of dialogue text.\nThis value can be [rainbow]changed dynamically[/]\nif using [c_yellow][[scale,#][/].", true, , true),
				new LuiInput({ value: dial_text_scale, height: 40, placeholder: "123456", offset: 12, type_sfx: snd_txttype, color_normal: c_white, color_hover: c_gray, }).addEvent(LUI_EV_CREATE, function(e_) { e_.set(SYSTEMUI.dial_text_scale); })
				.addEvent(LUI_EV_VALUE_UPDATE, function(e_) { var value_ = real_ext(e_.get()), index_ = value_ == "" ? 2 : value_; SYSTEMUI.dial_text_scale = index_; }),
			]),
			
			new LuiRow().setFlexGrow(1).centerContent().addContent([
				new LuiText({ value: "Text Speed:", width: 110, text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }).setTooltip("Changes the typewriter's text speed.\nThis value can be [rainbow]changed dynamically[/]\nif using [c_yellow][[speed,#][/].", true, , true),
				new LuiInput({ value: typist_spd, height: 40, placeholder: "123456", offset: 12, type_sfx: snd_txttype, color_normal: c_white, color_hover: c_gray, }).addEvent(LUI_EV_CREATE, function(e_) { e_.set(SYSTEMUI.typist_spd); })
				.addEvent(LUI_EV_VALUE_UPDATE, function(e_) { var value_ = real_ext(e_.get()), index_ = value_ == "" ? 0.5 : value_; SYSTEMUI.typist_spd = index_; SYSTEMUI.typist_spd_orig = SYSTEMUI.typist_spd; typist.in(SYSTEMUI.typist_spd, SYSTEMUI.typist_smooth); }),
			]),
			
			new LuiRow().setFlexGrow(1).centerContent().addContent([
				new LuiText({ value: "Text HAlign:", width: 110, text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }).setTooltip("Changes the dialogue's horizontal alignment.\n[c_yellow]0[/] - Left, [c_yellow]1[/] - Center, [c_yellow]2[/] - Right\n[c_red]This will disable [c_yellow]auto-asterisk[/].", true, , true),
				new LuiInput({ height: 40, placeholder: "0 - Left, 1 - Center, 2 - Right", offset: 12, type_sfx: snd_txttype, color_normal: c_white, color_hover: c_gray, input_mode: LUI_INPUT_MODE.numbers, max_length: 1, }).bindVariable(self, "dial_text_halign")
				.addEvent(LUI_EV_VALUE_UPDATE, function(e_) { soup_checkout("dataalignh", false, true).setSubimg(real(e_.get() == "" ? "0" : e_.get())); dial_text_halign = real(e_.get() == "" ? "0" : e_.get()); }),
				new LuiImage({ value: spr_gui_alignment_h, maintain_aspect: false }).setSize(32, 32).addEvent(LUI_EV_CREATE, function(e_) { soup_store("dataalignh", e_, , true); }),
			]),
			
			new LuiRow().setFlexGrow(1).centerContent().addContent([
				new LuiText({ value: "Text VAlign:", width: 110, text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }).setTooltip("Changes the dialogue's vertical alignment.\n[c_yellow]0[/] - Top, [c_yellow]1[/] - Middle, [c_yellow]2[/] - Bottom\n[c_red]This will disable [c_yellow]auto-asterisk[/].", true, , true),
				new LuiInput({ height: 40, placeholder: "0 - Top, 1 - Middle, 2 - Bottom", offset: 12, type_sfx: snd_txttype, color_normal: c_white, color_hover: c_gray, input_mode: LUI_INPUT_MODE.numbers, max_length: 1, }).bindVariable(self, "dial_text_valign")
				.addEvent(LUI_EV_VALUE_UPDATE, function(e_) { soup_checkout("dataalignv", false, true).setSubimg(real(e_.get() == "" ? "0" : e_.get())); dial_text_valign = real(e_.get() == "" ? "0" : e_.get()); }),
				new LuiImage({ value: spr_gui_alignment_v, maintain_aspect: false }).setSize(32, 32).addEvent(LUI_EV_CREATE, function(e_) { soup_store("dataalignv", e_, , true); }),
			]),
			
			new LuiRow().setFlexGrow(1).centerContent().addContent([
				new LuiText({ value: "Line Spacing:", width: 130, text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }).setTooltip("Changes the gap between lines of dialogue.\nIs the line gap too big/ small for your font?\nChange this setting to your liking!\nUse [c_red]-1[/] or leave blank to reset.", true, , true),
				new LuiInput({ value: dial_text_line_spacing, height: 40, placeholder: "123456", offset: 12, type_sfx: snd_txttype, color_normal: c_white, color_hover: c_gray, }).addEvent(LUI_EV_CREATE, function(e_) { e_.set(SYSTEMUI.dial_text_line_spacing); })
				.addEvent(LUI_EV_VALUE_UPDATE, function(e_) { var value_ = real_ext(e_.get()), index_ = value_ == "" ? -1 : value_; SYSTEMUI.dial_text_line_spacing = index_; }),
			]),
			
			new LuiRow().setFlexGrow(1).centerContent().addContent([
				new LuiText({ value: "Auto Wrap:", width: 100, text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }).setTooltip("Whether to automatically wrap text to a new line\nif the text width exceeds the dialogue box.\nTurning this off means [c_yellow]you'll have to manually\nadd newline literals(\\n or [[newl] yourself.", true, , true),
				new LuiToggleSwitch({ value: dial_auto_wrap, ease: global.Ease.OutBack, sound_click: snd_bump, sound_click_pitch: 1.3,  }).bindVariable(self, "dial_auto_wrap"),
			]),
			
			new LuiRow().setFlexGrow(1).centerContent().addContent([
				new LuiText({ value: "Auto Page:", width: 100, text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }).setTooltip("Whether to automatically add new pages when\nyour text overflows the dialogue box.\n[c_yellow]This [c_red]disables[c_yellow] vertical text alignments if it's off.[c_white]\nPage created this way will [c_yellow]not start with\nan asterisk if auto-asterisk is on.", true, , true),
				new LuiToggleSwitch({ value: dial_auto_page, ease: global.Ease.OutBack, sound_click: snd_bump, sound_click_pitch: 1.3,  }).bindVariable(self, "dial_auto_page"),
			]),
			
			new LuiRow().setFlexGrow(1).centerContent().addContent([
				new LuiText({ value: "Right-To-Left:", width: 140, text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }).setTooltip("Whether dialogue should be read right-to-left.", true, , true),
				new LuiToggleSwitch({ value: dial_rtl, ease: global.Ease.OutBack, sound_click: snd_bump, sound_click_pitch: 1.3,  }).bindVariable(self, "dial_rtl"),
			]),
			
			new LuiHorizontalRule({ height: 5, }),
			new LuiRow().setFlexGrow(1).centerContent().addContent([
				new LuiText({ value: "Auto Asterisk:", width: 130, text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }).setTooltip("Whether to automatically add asterisks\nat the start of text.\nTurning this off means [c_yellow]you'll have\nto manually add asterisks yourself.", true, , true),
				new LuiToggleSwitch({ value: dial_point_auto, ease: global.Ease.OutBack, sound_click: snd_bump, sound_click_pitch: 1.3,  }).bindVariable(self, "dial_point_auto"),
			]),
			
			new LuiRow().setFlexGrow(1).centerContent().addContent([
				new LuiText({ value: "Asterisk Chr:", width: 130, text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }).setTooltip("The character(s) to be\nplaced at the beginning of text.\n[c_yellow]Only works for auto-asterisk.\nIf left blank, auto-asterisk will be disabled.", true, , true),
				new LuiInput({ value: dial_point_chr, height: 40, placeholder: ">, *, $, ->, @, etc.", offset: 12, type_sfx: snd_txttype, max_length: 2, color_normal: c_white, color_hover: c_gray, }).bindVariable(self, "dial_point_chr"),
			]),
			
			new LuiRow().setFlexGrow(1).centerContent().addContent([ //Choosing a color
				new LuiText({ value: "Asterisk Color:", width: 140, text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }).setTooltip("Changes the color of the auto-asterisk.", true, , true),
				new LuiButton({ text: "Pick...", height: 40, }).addEvent(LUI_EV_CLICK, soupy_color_picker_asterisk),
				new LuiImage({ value: spr_pixel, maintain_aspect: false, color: dial_point_clr }).setSize(80, 40).addEvent(LUI_EV_CREATE, function(e_) { soup_store("dataasterisk", e_, , true); }).addEvent(LUI_EV_MOUSE_LEFT_PRESSED, function(element_) { element_.main_ui.animate(element_, "xscale", 0, 1, global.Ease.OutElastic, 10); element_.main_ui.animate(element_, "yscale", 0, 1, global.Ease.OutElastic, 5); sfx_play(snd_squish); })
				.addEvent(LUI_EV_VALUE_UPDATE, function(e_) { e_.set(spr_pixel); SYSTEMUI.dial_point_clr = e_.color_blend; audio_stop_sound(snd_equip2); sfx_play(snd_equip2, , , 1.3); }).addEvent(LUI_EV_CLICK_R, function(e_) { if ( e_.color_blend == c_white ) { exit; } e_.main_ui.animate(e_, "xscale", 0, 1, global.Ease.OutElastic, 10); e_.main_ui.animate(e_, "yscale", 0, 1, global.Ease.OutElastic, 5); e_.setColor(c_white); SYSTEMUI.dial_point_clr = c_white; sfx_play(snd_hurtpowerful); }),
			]),
			
			new LuiHorizontalRule({ height: 5, }),
			new LuiRow().setFlexGrow(1).centerContent().addContent([
				new LuiText({ value: "Text Shadow:", width: 130, text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }).setTooltip("Whether text should cast a shadow.", true, , true),
				new LuiToggleSwitch({ value: dial_text_shdw, ease: global.Ease.OutBack, sound_click: snd_bump, sound_click_pitch: 1.3,  }).bindVariable(self, "dial_text_shdw"),
			]),
			
			new LuiRow().setFlexGrow(1).centerContent().addContent([ //Choosing a color
				new LuiText({ value: "Shadow Color:", width: 130, text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }).setTooltip("Changes the color of the shadow.\n[c_yellow]Only works if text shadows are enabled.", true, , true),
				new LuiButton({ text: "Pick...", height: 40, }).addEvent(LUI_EV_CLICK, soupy_color_picker_shadow),
				new LuiImage({ value: spr_pixel, maintain_aspect: false, color: dial_text_shdw_clr }).setSize(80, 40).addEvent(LUI_EV_CREATE, function(e_) { soup_store("datashadow", e_, , true); }).addEvent(LUI_EV_MOUSE_LEFT_PRESSED, function(element_) { element_.main_ui.animate(element_, "xscale", 0, 1, global.Ease.OutElastic, 10); element_.main_ui.animate(element_, "yscale", 0, 1, global.Ease.OutElastic, 5); sfx_play(snd_squish); })
				.addEvent(LUI_EV_VALUE_UPDATE, function(e_) { e_.set(spr_pixel); SYSTEMUI.dial_text_shdw_clr = e_.color_blend; audio_stop_sound(snd_equip2); sfx_play(snd_equip2, , , 1.3); }).addEvent(LUI_EV_CLICK_R, function(e_) { if ( e_.color_blend == c_deltarune ) { exit; } e_.main_ui.animate(e_, "xscale", 0, 1, global.Ease.OutElastic, 10); e_.main_ui.animate(e_, "yscale", 0, 1, global.Ease.OutElastic, 5); e_.setColor(c_deltarune); SYSTEMUI.dial_text_shdw_clr = c_deltarune; sfx_play(snd_hurtpowerful); }),
			]),
			
			new LuiHorizontalRule({ height: 5, }),
			new LuiRow().setFlexGrow(1).centerContent().addContent([
				new LuiText({ value: "Text Gradient:", width: 130, text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }).setTooltip("Whether [c_yellow][wheel]all[/] text should have a gradient.", true, , true),
				new LuiToggleSwitch({ value: dial_gradient, ease: global.Ease.OutBack, sound_click: snd_bump, sound_click_pitch: 1.3,  }).bindVariable(self, "dial_gradient").addEvent(LUI_EV_VALUE_UPDATE, function(e_) { dial_gradient_orig = e_.get(); }),
			]),
			
			new LuiRow().setFlexGrow(1).centerContent().addContent([ //Choosing a color
				new LuiText({ value: "Gradient Color:", width: 140, text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }).setTooltip("Changes the color of the gradient.\n[c_yellow]Only works if text gradients are enabled.", true, , true),
				new LuiButton({ text: "Pick...", height: 40, }).addEvent(LUI_EV_CLICK, soupy_color_picker_gradient),
				new LuiImage({ value: spr_pixel, maintain_aspect: false, color: dial_gradient_clr }).setSize(80, 40).addEvent(LUI_EV_CREATE, function(e_) { soup_store("datagradient", e_, , true); }).addEvent(LUI_EV_SHOW, function(e_) { e_.color_blend = SYSTEMUI.dial_gradient_clr; }).addEvent(LUI_EV_MOUSE_LEFT_PRESSED, function(element_) { element_.main_ui.animate(element_, "xscale", 0, 1, global.Ease.OutElastic, 10); element_.main_ui.animate(element_, "yscale", 0, 1, global.Ease.OutElastic, 5); sfx_play(snd_squish); })
				.addEvent(LUI_EV_VALUE_UPDATE, function(e_) { e_.set(spr_pixel); SYSTEMUI.dial_gradient_clr = e_.color_blend; SYSTEMUI.dial_gradient_clr_orig = SYSTEMUI.dial_gradient_clr; audio_stop_sound(snd_equip2); sfx_play(snd_equip2, , , 1.3); }).addEvent(LUI_EV_CLICK_R, function(e_) { if ( e_.color_blend == c_white ) { exit; } e_.main_ui.animate(e_, "xscale", 0, 1, global.Ease.OutElastic, 10); e_.main_ui.animate(e_, "yscale", 0, 1, global.Ease.OutElastic, 5); e_.setColor(c_white); SYSTEMUI.dial_gradient_clr = c_white; SYSTEMUI.dial_gradient_clr_orig = SYSTEMUI.dial_gradient_clr; sfx_play(snd_hurtpowerful); }),
			]),
			
			new LuiHorizontalRule({ height: 5, }),
			new LuiRow().setFlexGrow(1).centerContent().addContent([
				new LuiText({ value: "Text Smoothing:", width: 140, text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }).setTooltip("Changes how much text is visible while\ntyping out. Higher numbers will allow more\ntext to be visible as it fades in.", true, , true),
				new LuiInput({ value: typist_smooth, height: 40, placeholder: "123456", offset: 12, type_sfx: snd_txttype, color_normal: c_white, color_hover: c_gray, }).addEvent(LUI_EV_CREATE, function(e_) { e_.set(SYSTEMUI.typist_smooth); })
				.addEvent(LUI_EV_VALUE_UPDATE, function(e_) { var value_ = real_ext(e_.get()), index_ = value_ == "" ? 0 : value_; SYSTEMUI.typist_smooth = index_; typist.in(SYSTEMUI.typist_spd, SYSTEMUI.typist_smooth); }),
			]),
			
			new LuiButton({ text: "Edit Font Separation", height: 40, }).addEvent(LUI_EV_CLICK, external_edit_fonts),
			new LuiButton({ text: "Typewriter Animation Builder", height: 40, }).addEvent(LUI_EV_CLICK, external_edit_typew).setTooltip("Edit how the typewriter types out characters.\nBefore editing, set [c_yellow]text smoothing[/] to\na value [c_cyan]greater than 0[/]. Experiment with the\ntext smoothing value while editing this.", true, , true),

			new LuiHorizontalRule({ height: 5, }),
			new LuiRow().setFlexGrow(1).centerContent().addContent([
				new LuiText({ value: "Indicator Sprite:", width: 160, text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }).setTooltip("Changes the indicator sprite used\nwhen dialogue has ended.\n[c_yellow]Leave blank or -1 for no indicator.", true, , true),
				new LuiInput({ value: dial_indicator, height: 40, placeholder: "123456", offset: 12, type_sfx: snd_txttype, color_normal: c_white, color_hover: c_gray, }).addEvent(LUI_EV_CREATE, function(e_) { e_.set(SYSTEMUI.dial_indicator); })
				.addEvent(LUI_EV_VALUE_UPDATE, function(e_) {
					var value_ = e_.get(), face_ = get_face(value_), bord_ = get_border(value_), icon_ = get_icon(value_);
					if ( face_ == -1 && bord_ == -1 && icon_ == -1 ) { SYSTEMUI.dial_indicator = -1; soup_checkout("dataindic", false, true).set(SYSTEMUI.dial_indicator); }
					else {
						if ( face_ != -1 ) { SYSTEMUI.dial_indicator = face_; soup_checkout("dataindic", false, true).set(SYSTEMUI.dial_indicator); exit; } 
						if ( bord_ != -1 ) { SYSTEMUI.dial_indicator = bord_; soup_checkout("dataindic", false, true).set(SYSTEMUI.dial_indicator); exit; } 
						if ( icon_ != -1 ) { SYSTEMUI.dial_indicator = icon_; soup_checkout("dataindic", false, true).set(SYSTEMUI.dial_indicator); exit; }
					}
				}),
				new LuiImage({ value: dial_indicator, draw_normal: true, color: dial_text_c }).setSize(40, 40).addEvent(LUI_EV_CREATE, function(e_) { soup_store("dataindic", e_, , true); }).addEvent(LUI_EV_MOUSE_LEFT_PRESSED, function(element_) { element_.main_ui.animate(element_, "xscale", 0, 1, global.Ease.OutElastic, 10); element_.main_ui.animate(element_, "yscale", 0, 1, global.Ease.OutElastic, 5); sfx_play(snd_squish); })
				.addEvent(LUI_EV_VALUE_UPDATE, function(e_) { if ( SYSTEMUI.dial_indicator != -1 ) { e_.setSize(sprite_get_width(e_.get()), sprite_get_height(e_.get())); audio_stop_sound(snd_updated); sfx_play(snd_updated); } }).addEvent(LUI_EV_CLICK_R, function(e_) { if ( e_.value == -1 ) { exit; } e_.main_ui.animate(e_, "xscale", 0, 1, global.Ease.OutElastic, 10); e_.main_ui.animate(e_, "yscale", 0, 1, global.Ease.OutElastic, 5); e_.set(-1); SYSTEMUI.dial_indicator = -1; sfx_play(snd_hurtpowerful); }),
			]),
			
			new LuiRow().setFlexGrow(1).centerContent().addContent([
				new LuiText({ value: "Image Index:", width: 110, text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }).setTooltip("Changes the indicator's image index.", true, , true),
				new LuiInput({ value: dial_indicator_index, height: 40, placeholder: "123456", offset: 12, type_sfx: snd_txttype, color_normal: c_white, color_hover: c_gray, }).addEvent(LUI_EV_CREATE, function(e_) { e_.set(SYSTEMUI.dial_indicator_index); })
				.addEvent(LUI_EV_VALUE_UPDATE, function(e_) { var value_ = real_ext(e_.get()), index_ = value_ == "" ? 0 : value_; SYSTEMUI.dial_indicator_index = index_; soup_checkout("dataindic", false, true).setSubimg(index_); }),
			]),
			
			new LuiRow().setFlexGrow(1).centerContent().addContent([
				new LuiText({ value: "Image Speed:", width: 110, text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }).setTooltip("Changes the indicator's image speed.", true, , true),
				new LuiInput({ value: dial_indicator_index, height: 40, placeholder: "123456", offset: 12, type_sfx: snd_txttype, color_normal: c_white, color_hover: c_gray, }).addEvent(LUI_EV_CREATE, function(e_) { e_.set(SYSTEMUI.dial_indicator_index); })
				.addEvent(LUI_EV_VALUE_UPDATE, function(e_) { var value_ = real_ext(e_.get()), index_ = value_ == "" ? 0 : value_; SYSTEMUI.dial_indicator_spd = index_; soup_checkout("dataindic", false, true).imgspd = index_; }),
			]),
			
			new LuiRow().setFlexGrow(1).centerContent().addContent([
				new LuiText({ value: "Image Scale:", width: 110, text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }).setTooltip("Changes the indicator's image scale.", true, , true),
				new LuiInput({ value: dial_indicator_scale, height: 40, placeholder: "123456", offset: 12, type_sfx: snd_txttype, color_normal: c_white, color_hover: c_gray, }).addEvent(LUI_EV_CREATE, function(e_) { e_.set(SYSTEMUI.dial_indicator_scale); })
				.addEvent(LUI_EV_VALUE_UPDATE, function(e_) { var value_ = real_ext(e_.get()), index_ = value_ == "" ? 1 : value_; SYSTEMUI.dial_indicator_scale = index_; }),
			]),
			
			new LuiRow().setFlexGrow(1).centerContent().addContent([
				new LuiText({ value: "Image XOff:", width: 110, text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }).setTooltip("Changes the indicator's x offset.", true, , true),
				new LuiInput({ value: dial_indicator_xoff, height: 40, placeholder: "123456", offset: 12, type_sfx: snd_txttype, color_normal: c_white, color_hover: c_gray, }).addEvent(LUI_EV_CREATE, function(e_) { e_.set(SYSTEMUI.dial_indicator_xoff); })
				.addEvent(LUI_EV_VALUE_UPDATE, function(e_) { var value_ = real_ext(e_.get()), index_ = value_ == "" ? 0 : value_; SYSTEMUI.dial_indicator_xoff = index_; }),
			]),
			
			new LuiRow().setFlexGrow(1).centerContent().addContent([
				new LuiText({ value: "Image YOff:", width: 110, text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }).setTooltip("Changes the indicator's y offset.", true, , true),
				new LuiInput({ value: dial_indicator_yoff, height: 40, placeholder: "123456", offset: 12, type_sfx: snd_txttype, color_normal: c_white, color_hover: c_gray, }).addEvent(LUI_EV_CREATE, function(e_) { e_.set(SYSTEMUI.dial_indicator_yoff); })
				.addEvent(LUI_EV_VALUE_UPDATE, function(e_) { var value_ = real_ext(e_.get()), index_ = value_ == "" ? 0 : value_; SYSTEMUI.dial_indicator_yoff = index_; }),
			]),
			
			new LuiRow().setFlexGrow(1).centerContent().addContent([
				new LuiText({ value: "Blink Speed:", width: 110, text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }).setTooltip("Changes the indicator's blinking speed.\nMeasured in milliseconds.", true, , true),
				new LuiInput({ height: 40, placeholder: "123456", offset: 12, type_sfx: snd_txttype, color_normal: c_white, color_hover: c_gray, }).addEvent(LUI_EV_CREATE, function(e_) { e_.set(SYSTEMUI.dial_indicator_blink); })
				.addEvent(LUI_EV_VALUE_UPDATE, function(e_) { var value_ = real_ext(e_.get()), index_ = value_ == "" ? 300 : value_; SYSTEMUI.dial_indicator_blink = index_; soup_checkout("dataindic", false, true).blink = index_; }),
			]),
			
			new LuiRow().setFlexGrow(1).centerContent().addContent([ //Sprite image angle
					new LuiText({ value: "Image Angle:", width: 120, text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }).setTooltip("Changes the indicator's angle.", true, , true),
					new LuiSlider({ min_value: 0, color_text: c_black, color_text_drag: c_white, max_value: 360, rounding: true, display_value: true, bar_sprite: spr_border_header, bar_sprite_back: spr_border_header, }).addEvent(LUI_EV_CREATE, function(e_) { e_.set(SYSTEMUI.dial_indicator_angle); }).addEvent(LUI_EV_VALUE_UPDATE, function(e_) { 
						var value_ = real(e_.get()); SYSTEMUI.dial_indicator_angle = value_; soup_checkout("dataindic", false, true).angle = value_;
					}),
				]),
			
			new LuiRow().setFlexGrow(1).centerContent().addContent([ //Animation bounce back
				new LuiText({ value: "Bounce Back:", width: 110, text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }).setTooltip("Whether the indicator sprite should reverse\nits animation once its animation ends.", true, , true),
				new LuiToggleSwitch({ value: dial_indicator_anim, ease: global.Ease.OutBack, sound_click: snd_bump, sound_click_pitch: 1.3,  }).bindVariable(self, "dial_indicator_anim").addEvent(LUI_EV_VALUE_UPDATE, function(e_) { soup_checkout("dataindic", false, true).bounce = e_.get(); }),
			]),
		]);
		
		soupy_lui.addContent(soupy_panel_style); //Add everything to the main ui
	#endregion
		
	#region Extra Panel
		var x1_ = 10, y1_ = 45, x2_ = 600, y2_ = 385, w_ = x2_ - x1_, h_ = y2_ - y1_;
		soupy_panel_extra = new LuiScrollPanel({ x: 10, y: 45, width: w_, height: h_, scroll_pin_edge_offset:10, sprite_panel: false, sound_right: snd_throw, }) //Start containter
		.addContent([
			new LuiText({ value: "Trying to export your dialogue?", auto_width: false, auto_height: false, text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }).setPadding(3),
			new LuiText({ value: "Press either ESCAPE, F1, or END for export options!", auto_width: false, auto_height: false, text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }).setPadding(3),
			new LuiHorizontalRule({ height: 5, }),
			new LuiText({ value: "Quick Export Shortcuts:", auto_width: false, auto_height: false, text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }).setPadding(10),
			new LuiText({ value: "Quick Static: CTRL+Q | Quick Typewriter: CTRL+W", auto_width: false, auto_height: false, text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }).setPadding(3),
			new LuiText({ value: "Quick Stack: CTRL+E | Quick Animated: CTRL+R", auto_width: false, auto_height: false, text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }).setPadding(3),
			
			new LuiHorizontalRule({ height: 5, }),
			new LuiRow().setFlexGrow(1).centerContent().addContent([ //Choosing a color
				new LuiText({ value: "GIF BG Color:", width: 130, text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }).setTooltip("Changes the color of the [c_lime]green screen[/] for GIFs.\nGIFs don't support transparency, so this is needed.", true, , true),
				new LuiButton({ text: "Pick...", height: 40, }).addEvent(LUI_EV_CLICK, soupy_color_picker_gifcolor),
				new LuiImage({ value: spr_pixel, maintain_aspect: false, color: screenshot_back }).setSize(80, 40).addEvent(LUI_EV_CREATE, function(e_) { soup_store("datagifcolor", e_, , true); }).addEvent(LUI_EV_MOUSE_LEFT_PRESSED, function(element_) { element_.main_ui.animate(element_, "xscale", 0, 1, global.Ease.OutElastic, 10); element_.main_ui.animate(element_, "yscale", 0, 1, global.Ease.OutElastic, 5); sfx_play(snd_squish); })
				.addEvent(LUI_EV_VALUE_UPDATE, function(e_) { e_.set(spr_pixel); SYSTEMUI.screenshot_back = e_.color_blend; audio_stop_sound(snd_equip2); sfx_play(snd_equip2, , , 1.3); }).addEvent(LUI_EV_CLICK_R, function(e_) { if ( e_.color_blend == c_lime ) { exit; } e_.main_ui.animate(e_, "xscale", 0, 1, global.Ease.OutElastic, 10); e_.main_ui.animate(e_, "yscale", 0, 1, global.Ease.OutElastic, 5); e_.setColor(c_lime); SYSTEMUI.screenshot_back = c_lime; sfx_play(snd_hurtpowerful); }),
			]),
				
			new LuiRow().setFlexGrow(1).centerContent().addContent([
				new LuiText({ value: "Bigger Resolution:", width: 170, text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }).setTooltip("Export all dialogue in UTDR's native resolution of 640x480.\nHelpful for [c_yellow][slant]arbitrary borders[/] as your sprites may get\ncut off on export if you import a border of an unusual size.", true, , true),
				new LuiToggleSwitch({ value: global.pref.sizematters, ease: global.Ease.OutBack, sound_click: snd_bump, sound_click_pitch: 1.3,  }).bindVariable(global.pref, "sizematters").addEvent(LUI_EV_VALUE_UPDATE, function(e_) { SYSTEMUI.save_pref(); }),
			]),
			
			new LuiRow().setFlexGrow(1).centerContent().addContent([
				new LuiText({ value: "To The Top:", width: 110, text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }).setTooltip("If [c_yellow]Bigger Resolution is true[/], then this will\nsend the dialogue box to the top.", true, , true),
				new LuiToggleSwitch({ value: global.pref.sizematterstop, ease: global.Ease.OutBack, sound_click: snd_bump, sound_click_pitch: 1.3,  }).bindVariable(global.pref, "sizematterstop").addEvent(LUI_EV_VALUE_UPDATE, function(e_) { SYSTEMUI.save_pref(); }),
			]),
			
			new LuiHorizontalRule({ height: 5, }),
			new LuiRow().setFlexGrow(1).centerContent().addContent([ //Sprite image scale
				new LuiText({ value: "Update Delay:", width: 130, text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }).setTooltip("( - n# (45 recommended))\nChanges how long it takes for the generator\nto update your output text.\n[c_yellow]Lower values and frequent updating may cause\nlag or other unexpected issues.", true, , true),
				new LuiInput({ value: dial_updatet_max, height: 40, placeholder: "1 - n# (45 recommended)", offset: 12, type_sfx: snd_txttype, color_normal: c_white, color_hover: c_gray, input_mode: LUI_INPUT_MODE.numbers, }).bindVariable(self, "dial_updatet_max").addEvent(LUI_EV_VALUE_UPDATE, function(e_) { 
					var get_ = e_.get(), value_ = real(get_ == "" ? 45 : get_); SYSTEMUI.dial_updatet_max = value_;
				}),
			]),
			
			new LuiRow().setFlexGrow(1).centerContent().addContent([
				new LuiText({ value: "Hide Success:", width: 110, text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }).setTooltip("Hides the export success message.", true, , true),
				new LuiToggleSwitch({ value: global.pref.hidemessages, ease: global.Ease.OutBack, sound_click: snd_bump, sound_click_pitch: 1.3,  }).bindVariable(global.pref, "hidemessages").addEvent(LUI_EV_VALUE_UPDATE, function(e_) { SYSTEMUI.save_pref(); }),
			]),
			
			new LuiRow().setFlexGrow(1).centerContent().addContent([
				new LuiText({ value: "Update Check:", width: 110, text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }).setTooltip("Check for updates upon startup?", true, , true),
				new LuiToggleSwitch({ value: global.pref.checkupdates, ease: global.Ease.OutBack, sound_click: snd_bump, sound_click_pitch: 1.3,  }).bindVariable(global.pref, "checkupdates").addEvent(LUI_EV_VALUE_UPDATE, function(e_) { SYSTEMUI.save_pref(); }),
			]),
			
			new LuiRow().setFlexGrow(1).centerContent().addContent([
				new LuiText({ value: "Mute Audio:", width: 110, text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }).setTooltip("Disable all sound effects.", true, , true),
				new LuiToggleSwitch({ value: global.pref.killaudio, ease: global.Ease.OutBack, sound_click: snd_bump, sound_click_pitch: 1.3,  }).bindVariable(global.pref, "killaudio").addEvent(LUI_EV_VALUE_UPDATE, function(e_) { SYSTEMUI.save_pref(); }),
			]),
			
			new LuiRow().setFlexGrow(1).centerContent().addContent([ //Choosing a sprite
				new LuiText({ value: "Editor Font:", width: 110, text_halign: fa_center, text_valign: fa_middle, font: fnt_speech, }).setTooltip("Changes the textbox editor font.", true, , true),
				new LuiButton({ text: "Choose...", height: 40, width: 100, }).addEvent(LUI_EV_CLICK, external_choose_font),
				new LuiInput({ value: font_get_name(ui_mainfont), height: 40, placeholder: "or type. (ex: fnt_determination)", offset: 12, type_sfx: snd_txttype, color_normal: c_white, color_hover: c_gray, }).addEvent(LUI_EV_CREATE, function(e_) { soup_store("datainputbox", e_, , true); }).addEvent(LUI_EV_VALUE_UPDATE, function(e_) { 
					var prev_ = soup_checkout("datafontbox", false, true), value = e_.get(); prev_.font = scribble_font_exists(value) ? value : "fnt_speech";
					if ( scribble_font_exists(value) ) { audio_stop_sound(snd_updated); sfx_play(snd_updated); }
					SYSTEMUI.ui_mainfont = asset_get_index(prev_.font);
					SYSTEMUI.textinput.SetFont(SYSTEMUI.ui_mainfont);
				}),
				new LuiText({ value: "AaBbCc", width: 100, text_halign: fa_center, text_valign: fa_middle, font: font_get_name(ui_mainfont), scribbletext: true, }).addEvent(LUI_EV_CREATE, function(e_) { soup_store("datafontbox", e_, , true); })
				.addEvent(LUI_EV_MOUSE_LEFT_PRESSED, function(element_) { element_.main_ui.animate(element_, "yoff", 0, 1, global.Ease.OutElastic, 10); sfx_play(snd_squish); })
				.addEvent(LUI_EV_CLICK_R, function(element_) {
					var input_ = soup_checkout("datainputbox", false, true), spr_ = soup_checkout("datafontbox", false, true);
					if ( spr_.font != "fnt_speech" && input_.get() != "" ) { spr_.font = "fnt_speech"; input_.set(""); sfx_play(snd_hurtpowerful); audio_stop_sound(snd_updated); }
				}),
			]),
			
			new LuiHorizontalRule({ height: 5, }),
			new LuiButton({ text: "Help Guide", height: 40, }).addEvent(LUI_EV_CLICK, function() { execute_shell_simple("https://rentry.co/utdrsoupguides", , , 0); }),
			new LuiButton({ text: "So Soupy!!", height: 40, }).addEvent(LUI_EV_CLICK, function() { execute_shell_simple("https://www.youtube.com/watch?v=zbClYRnQQJ0", , , 0); }),
			new LuiButton({ text: "Credits", height: 40, }).addEvent(LUI_EV_CLICK, soupy_ui_credits),
		]);
		
		soupy_lui.addContent(soupy_panel_extra); //Add everything to the main ui
	#endregion

	#region Functions
		///@desc Show/ hide Lui on appropiate screens.
		ui_reset = function(updatelime_ = true) {
			if ( soupy_panel_portrait.visible ) { soupy_panel_portrait.hide(false); }
			if ( soupy_panel_border.visible ) { soupy_panel_border.hide(false); }
			if ( soupy_panel_style.visible ) { soupy_panel_style.hide(false); }
			if ( soupy_panel_extra.visible ) { soupy_panel_extra.hide(false); }
				
			var fx = true;
			switch ( ui_tab ) {
				case 0: { fx = false; } break;
				case 1: { soupy_panel_style.show(true); } break;
				case 2: { soupy_panel_portrait.show(true); } break;
				case 3: { soupy_panel_border.show(true); } break;
				case 4: { soupy_panel_extra.show(true); } break;
			}
			if ( fx && bord_visible ) { sfx_play(snd_enc1, 0, , 0.7); bord_visible = false; }
			else if ( !fx && !bord_visible ) { sfx_play(snd_enc1, 0, , 1.3); bord_visible = true; }
			if ( updatelime_ ) { soupy_lui.update(); }
		}
		ui_reset();
				
		///@desc Toggle between different exporting types and export the dialogue
		ui_export = function(type_ = 0, fmax_ = 180, delay_ = 60, quant_ = 1, xoff_ = 0, yoff_ = 0) {
			soup_store("tablast", ui_tab, , true); ui_tab = -1; ui_reset(false); ui_visible = false; 
			if ( !bord_visible ) { sfx_play(snd_enc1, 0, , 1.3); bord_visible = true; } sfx_play(snd_equip);
					
			switch ( type_ ) {
				case 0: { screenshot = true; screenshot_stacked = false; } break; //Take single screenshot, no typewriter
				case 1: { //Record till dialogue ends, typewriter
					with ( record ) { enabled = true; framesmax = 0; frames = 0; type = 1; delay = delay_; quant = quant_; }
					dial_text_gif = true;
				} break;
				case 2: { //Record for a set timer, no typewriter just animated text
					with ( record ) { enabled = true; framesmax = fmax_; frames = 0; type = 0; quant = quant_; }
				} break;
				case 3: { //Take a stack of screenshots, no typewriter
					var offstruct = {
						soupstack_yoff: yoff_, //Gap between dialogue box sprites
						soupstack_xoff: xoff_, //Shift the dialogue boxes to the right by this amount
					}
					screenshot = true; screenshot_stacked = true; instance_create_depth(0, 0, 0, obj_stacker, offstruct); 
				} break;
			}
		}
	#endregion
#endregion

#region Error Handling
	errname = $"{directory_get_temporary_path()}error_log.soupy";

	exception_unhandled_handler(function(err_) {
		var errlog = $"Error: {err_.longMessage}\nStack Trace: {err_.stacktrace}";
		show_debug_message($"--------------------------------------------------------------\nAn error has occured: {errlog}\n--------------------------------------------------------------\n\n");
			
		//Write the exception struct to a file
		var buff = buffer_create(string_byte_length(errlog), buffer_grow, 1); //Create a buffer with the size of the error message string, fixed with an aligment of 1
		buffer_write(buff, buffer_text, errlog); //Save the json to the new buffer..
		buffer_save(buff, errname); //Save the buffer to a new file of specified name
		buffer_delete(buff); //Delete buffer to prevent memory leaks
		
		game_restart_alt();
	});
#endregion

#region First Time
	var txt_ = "Ayy! Welcome to [wheel][c_gold]UTDR SoupGen![/]|I see that it's your first time booting this up.|I would recommend [c_yellow]reading the|[c_yellow]help guide before you continue[/].|SoupGen got a [slant]lot[/] of power to it compared|to your average UTDR textbox generator,|so do familarize yourself with what all you can do!| |With that being said, [wave][c_lime]I hope you enjoy|this beta release!| |Once you're done, just press ESC for export options!";
	
	save_pref = function () {
		var data_ = json_stringify(global.pref);
		var buff_ = buffer_create(string_byte_length(data_), buffer_fixed, 1);
		buffer_write(buff_, buffer_text, data_); buffer_save(buff_, PREF_SOUP); buffer_delete(buff_);
	}
	
	var save_ = function () {
		global.pref.firsttime = false;
		SYSTEMUI.save_pref();
		execute_shell_simple("https://rentry.co/utdrsoupguides", , , 0);
	}
	
	if ( global.pref.firsttime ) { soupy_message(txt_, "Let's get soupy!", 480, , , snd_dimbox, fnt_abaddon, save_, , true, , , fa_top); }
#endregion

#region Errors with Auto-loading
	if ( global.outputLogSkipped != "" ) {
		var result = string_split(global.outputLogSkipped, "|"), result_len = array_length(result), result_i = 0, arr_ = [];
		repeat ( result_len ) {
			var cur_ = result[result_i];
			array_push(arr_,  new LuiText({ value: cur_, text_halign: fa_center, text_valign: fa_middle, font: fnt_abaddon, color: c_white, xoff: 0, y: 10 }));
		result_i++; }
	
		array_push(arr_,  new LuiText({ value: "These sprites were not loaded due to\neither incorrect filenames or file structure.", text_halign: fa_center, text_valign: fa_middle, font: fnt_abaddon, color: c_white, xoff: 0, y: 10 }));
		array_push(arr_,  new LuiText({ value: "If you need help, please refer to the SoupGen guide. (Click me!)", text_halign: fa_center, text_valign: fa_middle, font: fnt_abaddon, color: c_white, xoff: 0, y: 10 })
			.addEvent(LUI_EV_CLICK, function(element_) { sfx_play(snd_select); execute_shell_simple("https://rentry.co/utdrsoupguides", , , 0); })
			.addEvent(LUI_EV_MOUSE_ENTER, function(element_) { element_.color = c_gold; sfx_play(snd_sel_switch); element_.main_ui.animate(element_, "xoff", 10, 0.30, global.Ease.OutBack, 0); })
			.addEvent(LUI_EV_MOUSE_LEAVE, function(element_) { element_.color = c_white; element_.main_ui.animate(element_, "xoff", 0, 0.15); })
		);
	
		var maincan = new LuiScrollPanel({ sprite_panel: false, scroll_slider_width: 10, height: 390, }).addContent(arr_);
		soupy_popup([ maincan, ], , "Oh no!", , 460, , snd_error, fnt_abaddon, global.pref.firsttime ? true : false, 0, 40); 
	}
#endregion