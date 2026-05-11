///@desc Load Face & Border
var result = soup_checkout("external face");
if ( result != undefined ) {
	var curface = global.faces_dict[$ result.myname], spr_ = curface[$ result.id_].sprite, extra_ = is_undefined(soup_checkout("allowmultiple", false));
	sprite_set_offset(spr_, sprite_get_width(spr_)/ 2, sprite_get_height(spr_)/ 2); //Center sprite
	if ( extra_ ) { FACE_CURRENT = spr_; FACE_ORIGINAL = FACE_CURRENT; FACE_INTERNAL = result.myname; }
	
	soupy_message(result.msg, , , , , snd_sparkle2, , , !extra_ ? true : false);
	file_dragging = false;
}

var result = soup_checkout("external border");
if ( result != undefined ) {
	var curface = global.bords_dict[$ result.myname], spr_ = curface.sprite, extra_ = is_undefined(soup_checkout("allowmultiple", false));
	sprite_set_offset(spr_, sprite_get_width(spr_)/ 2, sprite_get_height(spr_)/ 2); //Center sprite
	
	if ( extra_ ) { spr_bord = spr_; bord_prev = spr_bord; if ( bord_spd == 0 ) { bord_spd = 0.15; } bord_anim = 0; }

	soupy_message(result.msg, , , , , snd_sparkle2, , , !extra_ ? true : false);
	file_dragging = false;
}