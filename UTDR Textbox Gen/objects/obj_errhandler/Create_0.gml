///@desc 
scribble_anim_shake(1, 0.1);
sfx_play(snd_error);
xscale = 1; yscale = 1; angle = 0;
TweenFire(self, EaseInOutQuad, 2, 0, 0, random_range(30, 180), "xscale", 5, 3, "yscale", 2, 5);
TweenFire(self, EaseLinear, 3, 0, 0, random_range(60, 180), "angle>", choose(360, -360));
err = scribble($"[c_white][scale,2]Ayy! Sorry, but an [wave][c_yellow]error[c_white][/wave] has occured...[/]\n\n[shake][c_red]{err_}[/shake][c_white]");
err.wrap(room_width - 30);
if ( instance_exists(obj_updatechecker) ) { instance_destroy(obj_updatechecker); }