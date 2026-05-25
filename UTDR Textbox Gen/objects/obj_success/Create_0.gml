///@desc 
io_clear();
image_speed = 0;
image_index = 6;
image_blend = c_lime;
image_xscale = 0;
image_yscale = 0;
x = room_width/ 2;
y = room_height/ 2;
image_angle = 360 * 3;
depth = -1;
alpha = 0;

var tween = TweenFire("$60", "~oback", "image_angle>", 0, "scale!>", 10);
TweenMore(tween, "$15", "alpha", 0.5, 0);
tween = TweenMore(tween, "$30", "+60", "image_xscale>", 40, "image_yscale>", 0);
TweenDestroyWhenDone(tween, , true);