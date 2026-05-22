///@desc It's just a line.
/// Available parameters:
/// color
///@arg {Struct} [_params] Struct with parameters
function LuiHorizontalRule(_params = {}) : LuiBase(_params) constructor {
	self.line_color = _params[$ "color"] ?? undefined;
	self.outline = _params[$ "outline"] ?? true; self.outline_c = _params[$ "outline_clr"] ?? c_black; self.outline_t = _params[$ "outline_thickness"] ?? ( self.outline ? 2 : 0 );
	self.setPadding(self.outline_t);
	self.draw = function() {
		var _blend_color = !is_undefined(self.line_color) ? self.line_color : self.style.color_secondary;
		if ( self.outline ) { draw_sprite_stretched_ext(spr_pixel, 0, self.x - self.outline_t, self.y - self.outline_t, self.width + ( self.outline_t * 2 ), self.height + ( self.outline_t * 2 ), self.outline_c, 1); }
		draw_sprite_stretched_ext(spr_pixel, 0, self.x, self.y, self.width, self.height, _blend_color, 1);
	}
}