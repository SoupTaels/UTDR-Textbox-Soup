///@desc Load Face & Border
var result = soup_checkout("external face");
if ( result != undefined ) {
	var curface = global.faces_dict[$ result.myname], spr_ = curface[$ result.id_].sprite;
	sprite_set_offset(spr_, sprite_get_width(spr_)/ 2, sprite_get_height(spr_)/ 2); //Center sprite
	dial_face[dial_text_page] = spr_;
	dial_face_original[dial_text_page] = dial_face[dial_text_page];
	
	soupy_message(result.msg, , , , , snd_sparkle2);
}

var result = soup_checkout("external border");
if ( result != undefined ) {
	var curface = global.bords_dict[$ result.myname], spr_ = curface.sprite;
	sprite_set_offset(spr_, sprite_get_width(spr_)/ 2, sprite_get_height(spr_)/ 2); //Center sprite
	
	spr_bord = spr_; 
	bord_prev = spr_bord;
	if ( bord_spd == 0 ) { bord_spd = 0.15; }
	bord_anim = 0;

	soupy_message(result.msg, , , , , snd_sparkle2);
}