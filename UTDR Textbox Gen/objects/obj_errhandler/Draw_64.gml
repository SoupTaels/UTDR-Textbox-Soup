///@desc 
err.draw(10, 5);
draw_sprite_ensure(get_icon("annoyingdog"), current_time/ 200, room_width - 60, 60, xscale, yscale, angle, make_color_hsv(current_time/ 100 mod 255, 255, 255));

scribble($"Press [c_lime](ENTER)[/c] to start the tool. Don't worry, your last updated text has been [c_yellow][wave]saved and restored!").draw(10, 460);