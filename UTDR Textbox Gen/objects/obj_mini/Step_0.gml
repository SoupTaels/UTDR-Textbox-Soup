///@desc 
//if ( live_call() ) { return live_result; } 
if ( SYSTEMUI.ui_paused || SYSTEMUI.ui_tab > 0 || !SYSTEMUI.bord_visible ) { alpha = 1; active = false; once = false; exit; }
if ( SYSTEMUI.dial_text_page != page ) { alpha = 1; once = false; exit; }
else { 
	if ( SYSTEMUI.screenshot ) { active = true; exit; } //Instantly show for screenshots
	else if ( SYSTEMUI.record.enabled && SYSTEMUI.record.type == 0 ) { active = true; if ( !once ) { once = true; alpha = 1; TweenFire("$13", $"~{smooth ? "oquad" : "linear"}", "xoff", 30, 0, "alpha", 0, 1); } } //Show animation
} 

if ( !SYSTEMUI.record.enabled && !SYSTEMUI.screenshot ) {
	var ww_ = sprite_get_width(face), hh_ = sprite_get_height(face), xx_ = x - ( ww_/ 2 ), yy_ = y - ( hh_/ 2 );
	var textx = ( xx_ + ww_ ) + 10, texty = yy_ + hh_, bbox = scrib.get_bbox(textx, texty);
	near = range_within(mouse_x_gui, xx_, textx + real(bbox.width)) && range_within(mouse_y_gui, yy_, texty + ( real(bbox.height)/ 2 )); //If within hitbox range
	alpha = lerp(alpha, ( near || drag ) ? 1 : 0.5, 0.15);
	
	if ( mouse_pressed && near ) { sfx_play(snd_enc1); drag = true; } //Pickup and enable dragging
	else { if ( mouse_released && drag ) { sfx_play(snd_squish); drag = false; } } //Release from pick up state
	
	if ( drag ) { x = round(lerp(x, mouse_x_gui, 0.3)); y = round(lerp(y, mouse_y_gui, 0.3)); } //Follow mouse cursor
	y = max(y, 300);
	if ( ( x < 0 || x > 640 || y > 480 ) && !drag ) { x = lerp(x, 300, 0.15); y = lerp(y, 350, 0.15); }
	
	if ( mouse_check_right && near ) { //Destroy mini object
		soupy_alarm("destroy", 60);
		soupy_alarm_run("destroy", 0, function () { sfx_play(snd_hurtX); instance_destroy(); });
		destroying = true;
	}
	else { soupy_alarm_set("destroy", "timer", 60); destroying = false; }
}
else { if ( !active ) { alpha = 0; once = false; } }