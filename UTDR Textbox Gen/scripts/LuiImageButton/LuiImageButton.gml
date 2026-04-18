///@desc This item displays the specified sprite with certain settings but works like a button.
/// Available parameters:
/// value
/// subimg
/// color
/// alpha
/// maintain_aspect
///@arg {Struct} [_params] Struct with parameters
function LuiImageButton(_params = {}) : LuiImage(_params) constructor {
	
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
				_blend_color = merge_color(_blend_color, self.style.color_hover, 0.5);
				if self.is_pressed {
					_blend_color = merge_color(_blend_color, c_black, 0.5);
				}
			}
		} else {
			_blend_color = merge_color(_blend_color, c_black, 0.5);
		}
		//Draw sprite button
		var _sprite_render_function = self.style.sprite_render_function ?? draw_sprite_stretched_ext;
		if !is_undefined(self.value) && sprite_exists(self.value) {
			_sprite_render_function(self.value, self.subimg, 
										floor(self.x + self.width/2 - _width/2), 
										floor(self.y + self.height/2 - _height/2), 
										_width, _height, 
										_blend_color, self.alpha);
		}
	}
	
	self.addEvent(LUI_EV_CLICK, function(_element) {
		if !is_undefined(_element.style.sound_click) {
			audio_play_sound(_element.style.sound_click, 1, false);
		}
	});
}