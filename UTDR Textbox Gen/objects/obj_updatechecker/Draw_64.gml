///@desc 
//if ( live_call() ) { return live_result; }
if ( !global.pref.checkupdates ) { exit; }
var upd_ = scribble(text), bbox_ = {}, x_ = room_width/ 2;
upd_.starting_format("fnt_speech", c_white).align(fa_center, fa_middle).padding(20, 20, 20, 20)
	
bbox_ = upd_.get_bbox(x_, text_y);
draw_sprite_stretched(spr_border_undertale_outlined, 0, bbox_.left, bbox_.top, bbox_.width, bbox_.height);
upd_.draw(x_, text_y);