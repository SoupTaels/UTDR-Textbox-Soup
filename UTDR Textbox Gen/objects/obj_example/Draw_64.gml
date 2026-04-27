var _x = 10;
var _y = 10;

draw_set_color(c_white);
draw_set_font(fnt_default);
var _str = "Interactive Demo\n\nPress F1 through F4 to change themes.";
draw_text(_x, _y, _str);
_y += string_height(_str) + 5;
var _code_y = _y;
box_name.Draw(_x, _y, 320);
_y += box_name.GetHeight() + 5;
box_password.Draw(_x, _y, 320);
_y += box_password.GetHeight() + 5;

box_notes.Draw(_x, _y);

_y = _code_y;
_x += box_name.GetWidth() + 5;

draw_set_color(c_aqua);
draw_text(_x, _y, "Bound name: " + string(model.name));
draw_text(_x, _y + 18, "Bound password len: " + string(string_length(model.password)));

QuillDrawOverlays();