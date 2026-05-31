///@desc
var mousein = ( mouse_check && ( range_within(mouse_x_gui, 0, 640) && range_within(mouse_y_gui, -60, 0) ) );
var xx_ = display_get_gui_width()/ 2, yy_ = -60, exp_ = scribble("[rainbow][wheel]Soupy Export! (Android Edition)")
.scale(2).padding(10, 10, 10, 10).align(fa_center, fa_top).starting_format(fnt_determination_nomono, mousein ? c_yellow : c_white);

var bbox_ = exp_.get_bbox(xx_, yy_);
draw_sprite_stretched_ext(spr_border_undertale_outlined, 0, 0, yy_, 640, bbox_.height, mousein ? c_yellow : c_white, 1);
exp_.draw(xx_, yy_);