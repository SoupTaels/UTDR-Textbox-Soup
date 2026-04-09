function on_enter_() { audio_play_sound(snd_sel_switch, 0, false); TweenFire("~ocirc", "$15", "y>", "ystart+5"); text = $"[c_yellow][wheel]{text_static}"; color_butt = c_yellow; }
function on_leave_() { TweenFire("~ocirc", "$15", "y>", "ystart"); text = text_static; color_butt = c_orange; }
function on_click_() { audio_play_sound(snd_select, 0, false); obj_system.ui_tab = id_; } 

function ui_manage() {
	live_auto_call 

	switch ( ui_tab ) {
		case 0: { //Dialogue
			var txt_ = scribble("Dialogue Tab")
							.align(fa_center, fa_middle)
							.scale(3)
							.draw(320, 220);
		} break;
		
		case 1: { //Face
			var txt_ = scribble("Face Tab")
							.align(fa_center, fa_middle)
							.scale(3)
							.draw(320, 220);
		} break;
		
		case 2: { //Border
			var txt_ = scribble("Border Tab")
							.align(fa_center, fa_middle)
							.scale(3)
							.draw(320, 220);
		} break;
		
		case 3: { //About
			scribble_anim_wheel(3, SCRIBBLE_DEFAULT_WHEEL_FREQUENCY, SCRIBBLE_DEFAULT_WHEEL_SPEED);
			var txt_ = scribble("[rainbow][wheel]So soupy!!")
							.align(fa_center, fa_middle)
							.scale(3)
							.draw(320, 220);
			scribble_anim_wheel(SCRIBBLE_DEFAULT_WHEEL_SIZE, SCRIBBLE_DEFAULT_WHEEL_FREQUENCY, SCRIBBLE_DEFAULT_WHEEL_SPEED);
		} break;
	}
}