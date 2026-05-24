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
	self.subimg = _params[$ "subimg"] ?? 0;
	self.angle = _params[$ "angle"] ?? 0;
	self.imgspd = _params[$ "imgspd"] ?? 0;
	self.xscale = _params[$ "xscale"] ?? 1;
	self.yscale = _params[$ "yscale"] ?? 1;
	self.color_default = self.color_blend;
	self.bounce = false;
	self.anim_track = false; self.blink = -1;
	self.step = function () { 
		if ( self.imgspd > 0 ) {
			var amt = sprite_get_number(self.value);
			if ( !self.bounce ) { self.subimg += self.imgspd; if ( self.subimg >= amt ) { self.subimg = 0; } }
			else { 
				if ( !self.anim_track ) { self.subimg += self.imgspd mod amt; if ( round(self.subimg) >= amt) { self.anim_track = true; } }
				else { self.subimg -= self.imgspd; if ( round(self.subimg) <= 0) { self.anim_track = false; } }
			}
			self.updateMainUiSurface();
		};
		
		if ( self.blink != -1 ) { self.updateMainUiSurface(); }
	}
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
		if ( !is_undefined(self.value) && self.value != -1 && self.value != "" && sprite_exists(self.value) ) {
			if ( self.blink == -1 || ( self.blink != -1 && blink(self.blink - 100, self.blink) ) ) {
				if ( !self.draw_normal ) {
					var _sprite_render_function = self.style.sprite_render_function ?? draw_sprite_stretched_ext;
						_sprite_render_function(self.value, self.subimg, 
													floor(self.x + self.width/2 - _width/2) - self.xscale, 
													floor(self.y + self.height/2 - _height/2) - self.yscale, 
													_width + ( self.xscale * 2 ), _height + ( self.yscale * 2 ), 
													_blend_color, self.alpha);
				}
				else {
					draw_sprite_ext(self.value, self.subimg, self.x + self.width/2, self.y + self.height/2, self.xscale, self.yscale, self.angle ?? 0, _blend_color, self.alpha);
				}
			}
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