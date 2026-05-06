///@desc This item displays the specified sprite with certain settings but works like a button.
/// Available parameters:
/// value
/// subimg
/// color
/// alpha
/// maintain_aspect
///@arg {Struct} [_params] Struct with parameters
function LuiImageButton(_params = {}) : LuiImage(_params) constructor {
	self.params = _params;
	self.draw_normal = _params[$ "draw_normal"] ?? false;
	self.color_hover = _params[$ "color_hover"];
	self.draw = function() {
		//Calculate fit size
		var _width = self.width;
		var _height = self.height;
		if self.maintain_aspect {
			if _width / self.aspect <= self.height  {
				_height = _width / self.aspect;
			} else {
				_width = _height * self.aspect;
			}
		}
		//Get blend color
		var _blend_color = self.color_blend;
		if !self.deactivated {
			if self.isMouseHovered() {
				_blend_color = merge_color(_blend_color, self.color_hover ?? self.style.color_hover, 0.5);
				if self.is_pressed {
					_blend_color = merge_color(_blend_color, c_black, 0.5);
				}
			}
		} else {
			_blend_color = merge_color(_blend_color, c_black, 0.5);
		}
		//Draw sprite button
		if ( !self.draw_normal ) {
			var _sprite_render_function = self.style.sprite_render_function ?? draw_sprite_stretched_ext;
			if !is_undefined(self.value) && sprite_exists(self.value) {
				_sprite_render_function(self.value, self.subimg, 
											floor(self.x + self.width/2 - _width/2), 
											floor(self.y + self.height/2 - _height/2), 
											_width, _height, 
											_blend_color, self.alpha);
			}
		}
		else {
			draw_sprite_ext(self.value, self.subimg, self.x + self.width/2, self.y + self.height/2, 1, 1, self.params[$ "angle"] ?? 0, _blend_color, self.alpha); 
		}
	}
	
	self.addEvent(LUI_EV_CLICK, function(_element) {
		if !is_undefined(_element.style.sound_click) {
			sfx_play(self.params[$ "sound_click"] ?? _element.style.sound_click, , self.params[$ "sound_click_gain"] ?? 1, self.params[$ "sound_click_pitch"] ?? 1);
		}
	});
	
	self.addEvent(LUI_EV_MOUSE_ENTER, function(_element) {
		if !is_undefined(_element.style.sound_hover) {
			sfx_play(self.params[$ "sound_hover"] ?? _element.style.sound_hover, , self.params[$ "sound_hover_gain"] ?? 1, self.params[$ "sound_hover_pitch"] ?? 1);
		}
	});
}