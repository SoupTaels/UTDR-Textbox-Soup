///@desc Load Face & Border
var result = async_load;
if ( file_dragging_face != -1 ) { //face
	var curface = global.faces_dict[$ file_dragging_face.myname], spr_ = curface[$ file_dragging_face.id_].sprite;
	sprite_set_offset(spr_, sprite_get_width(spr_)/ 2, sprite_get_height(spr_)/ 2); //Center sprite
	dial_face[dial_text_page] = spr_;
	dial_face_original[dial_text_page] = dial_face[dial_text_page];
	
	soupy_message(file_dragging_face.msg, , , , , snd_sparkle2);
	file_dragging_face = -1;
}

if ( file_dragging_bord != -1 ) { //border
	var curface = global.bords_dict[$ file_dragging_bord.myname], spr_ = curface.sprite;
	sprite_set_offset(spr_, sprite_get_width(spr_)/ 2, sprite_get_height(spr_)/ 2); //Center sprite
	
	spr_bord = spr_; 
	bord_prev = spr_bord;
	if ( bord_spd == 0 ) { bord_spd = 0.15; }
	bord_anim = 0;

	soupy_message(file_dragging_bord.msg, , , , , snd_sparkle2);
	file_dragging_bord = -1;
}